Return-Path: <linux-kernel-owner+w=401wt.eu-S967920AbXFHM6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967920AbXFHM6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937318AbXFHM5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:57:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56015 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S938171AbXFHM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:57:51 -0400
Date: Fri, 8 Jun 2007 14:01:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070608140150.6f31672f@the-village.bc.nu>
In-Reply-To: <20070608120746.GD12687@thunk.org>
References: <466741BD.20106@redhat.com>
	<20070607110432.73be7960@the-village.bc.nu>
	<B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
	<20070607151243.22caab9e.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
	<466864F8.2050903@cosmosbay.com>
	<46686810.6030805@redhat.com>
	<Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
	<466880A4.3090908@redhat.com>
	<Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
	<20070608120746.GD12687@thunk.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Um, how cheap do you need it?  get_random_int() is actually pretty
> cheep, since it was designed to be usable by the networking stack for
> sequence numbers for TCP packets; and it's not like sys_close() or
> sys_open() is a majorly critical path, is it?  If the concern is

At this point wouldn't it be cheaper to allocate file handles using a
different algorithm than firing up the RNG - say like in the POSIX
fashion ... 

It seems every purpose of this fd stuff is now a failure when
compared with existing behaviours.

