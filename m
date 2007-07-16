Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbXGPJK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbXGPJK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXGPJKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:10:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57438 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753825AbXGPJKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:10:47 -0400
Date: Mon, 16 Jul 2007 10:16:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch 2/2] x86_64: FIFO ticket spinlocks
Message-ID: <20070716101654.1c20493f@the-village.bc.nu>
In-Reply-To: <20070716050134.GB19914@wotan.suse.de>
References: <20070716045932.GA19914@wotan.suse.de>
	<20070716050134.GB19914@wotan.suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> however the difference is quite small on Core2 and Opteron when working out of
> cache, and becomes almost insignificant even on P4 when the lock misses cache.
> trylock is more significantly slower, but they are relatively rare.

This has a 255 processor limit (worst case). That should probably be
clearly documented for the future.

