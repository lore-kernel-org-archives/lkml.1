Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXKTSMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXKTSMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbXKTSMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:12:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXKTSMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:12:14 -0500
Message-ID: <47432267.4040202@redhat.com>
Date: Tue, 20 Nov 2007 10:07:35 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 4/6] Allow setting FD_CLOEXEC flag for new sockets
References: <200711200653.lAK6rE31025888@devserv.devel.redhat.com> <474320C4.2040600@oracle.com>
In-Reply-To: <474320C4.2040600@oracle.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Zach Brown wrote:
> Have you given thought to having to perform compat translation on this?
>   Today it's only copied directly from the user pointer into the union
> in the task_struct.

Since there is no legacy interface to worry about all members added to
the structure can and should be neutral of the word size.  We've done
this with some syscalls already (like pread64) where we always use the
wide form in the parameter list.  It's just more simple here since it
does not have to split into two 32-bit registers.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHQyJn2ijCOnn/RHQRAmWeAJ0Q6qBDtZDvsZYlfBnPFL6n11Z+lwCghiVp
NklFHsSnVyQYMD5rinDFQPo=
=Yo5E
-----END PGP SIGNATURE-----
