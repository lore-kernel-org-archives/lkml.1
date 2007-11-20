Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbXKTQM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbXKTQM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbXKTQMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:12:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760788AbXKTQMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:12:12 -0500
Message-ID: <4743071A.9050408@redhat.com>
Date: Tue, 20 Nov 2007 08:11:06 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 0/6] sys_indirect system call
References: <200711200653.lAK6rEYP025876@devserv.devel.redhat.com> <4742A51D.5080009@cosmosbay.com>
In-Reply-To: <4742A51D.5080009@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
> I am wondering if some parts are missing from your ChangeLog
> 
> You apparently added in v3 a new 'flags' parameter to indirect syscall
> but no trace of this change in Changelog, and why it was added. This
> seems to imply a future multiplexor.

This was mentioned in one of my mails.  I added the parameter to
accommodate Linus's and Zack's idea to use the functionality for syslets
as well.  Not really a multiplexer, it is meant to be a "execute
synchronously or asynchronously" flag.  In the latter case an additional
parameter might be needed to indicate the notification mechanism.


> And no change in the test program reflecting this 'flags' new param, so
> it fails.

Yep, sorry, I didn't update the text by including the most recent test
program.  I'll do that for the next version.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHQwca2ijCOnn/RHQRAgQJAKDH+N3+FSJ0kD5VbzbAFN4918wREwCePHbc
nSY/t9x1FuYstYDaaT6Kut0=
=c95e
-----END PGP SIGNATURE-----
