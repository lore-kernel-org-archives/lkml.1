Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbXKTSW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbXKTSW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759554AbXKTSWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:22:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945AbXKTSWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:22:19 -0500
Message-ID: <474324AE.3070404@redhat.com>
Date: Tue, 20 Nov 2007 10:17:18 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 0/6] sys_indirect system call
References: <200711200653.lAK6rEYP025876@devserv.devel.redhat.com> <4742A51D.5080009@cosmosbay.com> <4743071A.9050408@redhat.com> <4743229F.2060805@oracle.com>
In-Reply-To: <4743229F.2060805@oracle.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Zach Brown wrote:
> I'm sure the additional parameter will be needed, and it might be pretty
> involved.  I think the current notion of syslets needs, at the very least:

All correct.  I just want to point out that the proposed interface is
sufficiently prepared for this and that there is no need to wait adding
this initial, synchronous syscall stuff before the syslet stuff is
ready.  These interface changes are security-relevant and should be
added ASAP.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHQySu2ijCOnn/RHQRAnQqAKCz0JzvmAeEcL8m77jbEYAZ4ZFWXwCgpfvE
do7pJGn9XBu9jfQhfLkxQSc=
=eX6m
-----END PGP SIGNATURE-----
