Return-Path: <linux-kernel-owner+w=401wt.eu-S1765036AbYDXPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765036AbYDXPbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762678AbYDXPUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:20:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762605AbYDXPUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:20:53 -0400
Message-ID: <4810A4FF.7030004@redhat.com>
Date: Thu, 24 Apr 2008 08:19:27 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       michael.kerrisk@gmail.com, linux-man@vger.kernel.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>	<20080424112514.055d8071@the-village.bc.nu>	<517f3f820804240534r3bbbdc52s52a6dfe3f2d14b7f@mail.gmail.com>	<48109DFB.900@redhat.com> <20080424154220.3dae36a1@the-village.bc.nu>
In-Reply-To: <20080424154220.3dae36a1@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
> We shouldn't be seeing this as a Linux problem, its a BSD problem, an AIX
> problem, a Solaris problem and an HPUX problem and really wants one
> solution applying across distributions or it will harm everyone in the
> long term.

Look at the other interfaces.  I've proposed them for POSIX and they are
going to be in the next revision (O_CLOEXEC, F_DUPFD_CLOEXEC).  I'm
confident that whatever we'll do will be endorsed this way.  It's just
too late for the next revision, it'd have to wait a few years until work
on the next revision (esp reviews) start.  That's too long.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIEKT/2ijCOnn/RHQRAkyoAJ9/FRwN3r6zg2cSvzVrA2TiGlfergCdG1r9
H/UghrO5A99ieG6O7wXvu7I=
=pUfi
-----END PGP SIGNATURE-----
