Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbXEaTu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbXEaTu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbXEaTuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:50:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbXEaTuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:50:51 -0400
Message-ID: <465F270B.5090604@redhat.com>
Date: Thu, 31 May 2007 12:50:35 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com> <Pine.LNX.4.64.0705311123370.30485@alien.or.mcafeemobile.com> <465F170B.3070603@redhat.com> <Pine.LNX.4.64.0705311144290.30485@alien.or.mcafeemobile.com> <20070531190235.GY4033@devserv.devel.redhat.com> <Pine.LNX.4.64.0705311205520.30485@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705311205520.30485@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> What I meant, was that the vast majority of MT+exec 
> apps wants all their fds (but an handfull, maybe)

You never listen when you are told something.  Such a statement cannot
be made.  The application doesn't know what the runtime libraries need
(not just libc, libstdc++, libxml, whatever) and vice versa.  Policies
are always wrong for somebody and changing the standardized behavior is
not acceptable.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGXycL2ijCOnn/RHQRAvPfAJ9r77oMkReyf4OG2rVPaFNb5TIYfgCgwp8e
mvswKBbe1UlrzlG3oOWYswM=
=viNa
-----END PGP SIGNATURE-----
