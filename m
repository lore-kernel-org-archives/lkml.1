Return-Path: <linux-kernel-owner+w=401wt.eu-S1031449AbXFHSod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031449AbXFHSod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbXFHSoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:44:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937330AbXFHSoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:44:21 -0400
Message-ID: <4669A351.4010403@redhat.com>
Date: Fri, 08 Jun 2007 11:43:29 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Davide Libenzi <davidel@xmailserver.org>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <466741BD.20106@redhat.com>	<20070607110432.73be7960@the-village.bc.nu>	<B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>	<20070607151243.22caab9e.dada1@cosmosbay.com>	<Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>	<466864F8.2050903@cosmosbay.com>	<46686810.6030805@redhat.com>	<Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>	<466880A4.3090908@redhat.com>	<Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>	<20070608120746.GD12687@thunk.org>	<20070608140150.6f31672f@the-village.bc.nu>	<Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com> <20070608192652.4a291901@the-village.bc.nu>
In-Reply-To: <20070608192652.4a291901@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
> Why does he want an unpredictable algorithm

To avoid exactly the kind of problem we have now in future: programs
relying on specific patterns.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD4DBQFGaaNR2ijCOnn/RHQRAtGQAJUWlqUTHuxU7TMi+0tiEldqQPi0AJwIVOAx
lG6JQ9o6YNYVtCFOLyZLsg==
=0Vp+
-----END PGP SIGNATURE-----
