Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbXFGKBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbXFGKBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXFGKA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:00:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49342 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306AbXFGKAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:00:55 -0400
Date: Thu, 7 Jun 2007 11:04:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070607110432.73be7960@the-village.bc.nu>
In-Reply-To: <466741BD.20106@redhat.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606235906.72439d16@the-village.bc.nu>
	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
	<20070607001932.35c9591c@the-village.bc.nu>
	<466741BD.20106@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This has nothing to do with linking and ABI.  The assumptions about

It may not to someone who has their head in linkers all day and very
defined ideas about linkers but joining to pieces of code together and
figuring out if they can be combined is "linking", regardless of the
whether-they-can-be-joined being down to symbol availability, instruction
set, memory layout or assumptions about behaviour.

> continuous allocation are part of the API.  It's required by POSIX and
> provided by Unix since the early days.  There are entire code bases out
> there which depend on this assumption.  Linking with code like this,
> before or after the new version controlled symbol is introduced, will
> break it. 

If your linker is doing its job then you won't be able to link them
together because they have incompatible assumptions. Not exactly rocket
science even if it is done a little differently to the usual symbol
compatibility tests. 

> Policies or stateful behavior, however yo want to call it, is
> just plain wrong for this (and most other things).

And the stuff you are trying to put into the kernel is better ? No, its a
bunch of ugly hacks caused by trying to solve the problem in the wrong
way and in the wrong place.

Alan
