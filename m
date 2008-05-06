Return-Path: <linux-kernel-owner+w=401wt.eu-S1761753AbYEFDLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753AbYEFDLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYEFDK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:10:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbYEFDK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:10:58 -0400
Message-ID: <481FCC36.2010801@redhat.com>
Date: Mon, 05 May 2008 20:10:46 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
References: <200805050342.m453gktl029817@devserv.devel.redhat.com>	<20080505185850.789d870a.akpm@linux-foundation.org>	<481FC38A.6070805@redhat.com>	<20080505194221.4349418b.akpm@linux-foundation.org>	<481FC94C.8090203@redhat.com> <20080505200500.0d1018df.akpm@linux-foundation.org>
In-Reply-To: <20080505200500.0d1018df.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> What I meant was "what does this whole patchset do"?  Believe it or not,
> for a new reader, that is somewhat unobvious.  Perhaps one could work it out
> with sufficient googling and thread-trolling.

It adds flag parameters in all the places where none is present to
control aspects of the returned file descriptor(s).  So far atomic
close-on-exec and setting non-blocking mode are implemented.  More can
follow if wanted.  Similar to the O_CLOEXEC and F_DUPFD_CLOEXEC
extensions which I wrote several moons ago.  Just two weeks ago I pointed at

   http://bugzilla.redhat.com/show_bug.cgi?id=443321

as a case which we cannot really fix without these kind of extensions.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIH8w22ijCOnn/RHQRAjNvAJkBJxBR3uI8HfPIUqcMezLjFK/d2QCfXS4v
IH7T6AFb/j9V4tWtlWi0Bcs=
=lLFY
-----END PGP SIGNATURE-----
