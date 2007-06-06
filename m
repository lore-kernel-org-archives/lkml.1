Return-Path: <linux-kernel-owner+w=401wt.eu-S936581AbXFFXXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936581AbXFFXXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763575AbXFFXXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:23:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbXFFXXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:23:17 -0400
Message-ID: <466741BD.20106@redhat.com>
Date: Wed, 06 Jun 2007 16:22:37 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>	<20070606235906.72439d16@the-village.bc.nu>	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com> <20070607001932.35c9591c@the-village.bc.nu>
In-Reply-To: <20070607001932.35c9591c@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
> Linking to the correct version of a libary and getting the library
> versioning right is not rocket science and isn't a sane excuse. Its no
> different to the stdio to large fd migration issues with many Unixen and
> they all coped just fine.

This has nothing to do with linking and ABI.  The assumptions about
continuous allocation are part of the API.  It's required by POSIX and
provided by Unix since the early days.  There are entire code bases out
there which depend on this assumption.  Linking with code like this,
before or after the new version controlled symbol is introduced, will
break it.  Policies or stateful behavior, however yo want to call it, is
just plain wrong for this (and most other things).

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGZ0G92ijCOnn/RHQRAkB9AJ93ol7XV2GiCw+8wgbJ9uMBnHU6dQCgmmAp
9m+WEup3iPkEHH6HIHDa88I=
=Dhto
-----END PGP SIGNATURE-----
