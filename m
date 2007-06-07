Return-Path: <linux-kernel-owner+w=401wt.eu-S937431AbXFGWd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937431AbXFGWd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937475AbXFGWdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:33:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936581AbXFGWdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:33:04 -0400
Message-ID: <466880A4.3090908@redhat.com>
Date: Thu, 07 Jun 2007 15:03:16 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com> <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com> <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com> <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com> <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> What we can sanily do, is re-random the base if no fds are in there (of 
> course CLOFORK and CLOEXEC do not count).

With the last comment you mean "count after CLOFORK and CLOEXEC", right?
 So the re-basing would be done in two places: after fork and after execve?

That would be enough.  Programs should clean after themselves.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGaICk2ijCOnn/RHQRAqq5AJwIDmKdsL71ecQVd6PoDI2oOL/KcwCguj2b
TFqDhpJEDqFx1ypdHITuywA=
=Cbfg
-----END PGP SIGNATURE-----
