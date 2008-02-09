Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYBIOKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYBIOKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYBIOKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:10:08 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46095 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752392AbYBIOKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:10:06 -0500
Date: Sat, 9 Feb 2008 14:03:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Gene Heskett <gene.heskett@gmail.com>,
       Prakash Punnoor <prakash@punnoor.de>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Message-ID: <20080209140306.47f50c0f@core>
In-Reply-To: <20080209141852.GC22569@one.firstfloor.org>
References: <20080207195519.GA21772@basil.nowhere.org>
	<20080208160906.GA9642@one.firstfloor.org>
	<200802081839.18267.prakash@punnoor.de>
	<200802090746.25310.gene.heskett@gmail.com>
	<20080209141852.GC22569@one.firstfloor.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 15:18:52 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > Sort of coming in in the middle of this because I just realized this may have 
> > something to do with the "exception Emask" errors. I have an NF2, and the 
> 
> exception Emask is a SATA problem. Shouldn't be caused by timer troubles.
> This means in theory it could be that your sata driver if compiled
> in is the first thing to use timers, but normally if the timers are
> broken you get a earlier hang somewhere else.

Badly wrong timer speed would do that, as would the timer change breaking
other IRQ delivery somewhere

Alan
