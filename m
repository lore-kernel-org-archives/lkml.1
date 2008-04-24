Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbYDXQFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbYDXQFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbYDXQFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:05:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbYDXQFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:05:05 -0400
Message-ID: <4810AF9F.5040705@redhat.com>
Date: Thu, 24 Apr 2008 09:04:47 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>	<20080424112514.055d8071@the-village.bc.nu>	<481096C3.2020206@redhat.com>	<20080424152436.6cf53c1b@the-village.bc.nu>	<4810A46B.1090809@redhat.com>	<20080424160352.30f2dd5b@the-village.bc.nu>	<4810AB29.5030604@redhat.com> <20080424162703.1eec01a2@the-village.bc.nu>
In-Reply-To: <20080424162703.1eec01a2@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
> Believe it or not we have the compute capability between us to not
> accidentally reassign values we assigned to one thing to something else.

Once again, this is not about assigned values.  This is about the time
before you get a value assigned.  Not every experiment out there will
have a value assigned before it starts development.

But it really doesn't matter to me. I'm not the one you would introduce
the problem.  Patch is forthcoming.


>> Oh really?  You open a server socket, use fcntl(FD_CLOEXEC), and then
>> accept(). 
> 
> And your behaviour just became OS specific....

Not according to POSIX.  If some OSes deliberately violate POSIX that's
their problem.  All POSIX OSes will have up to today return a new file
descriptor without the close-on-exec flag set at all times.  Just read
the spec.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIEK+f2ijCOnn/RHQRAtYRAJ9Ve9XSkMriqkHkiCL00wsXzJJbYgCgmqzQ
3uexpcjM0NvU7qgngOs7LDA=
=uNKi
-----END PGP SIGNATURE-----
