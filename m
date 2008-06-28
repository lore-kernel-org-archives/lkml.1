Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYF1Kc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYF1Kc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 06:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbYF1Kcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 06:32:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYF1Kct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 06:32:49 -0400
Subject: Re: linux-next: Tree for June 26
From: David Woodhouse <dwmw2@infradead.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <1214646863.2660.22.camel@jaswinder.satnam>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au>
	 <200806270138.53895.rjw@sisk.pl>
	 <1214563913.10393.180.camel@pmac.infradead.org>
	 <200806280104.17527.rjw@sisk.pl>
	 <1214646863.2660.22.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Sat, 28 Jun 2008 11:32:44 +0100
Message-Id: <1214649164.10393.265.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-28 at 15:24 +0530, Jaswinder Singh wrote:
> Here is updated patch :-
> 
> http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commitdiff;h=aa8b184d8eb4f1d7b5e37d5ad449fb7c02ad79c2

You can ignore that; it's just the same as today's linux-next (which in
turn is just the same as yesterday's + the patch which fixes the problem
for Kamalesh but not for you + the other minor error path cleanup.

Please could you try the other debugging patch I just sent, on top of
today's linux-next? It should confirm that you're using the 'Tso5'
firmware, as I told Jaswinder yesterday, and give us a little more clue
as to what's going on.

This is your machine, right? ...

http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/1619.html

tg3.c:v3.81 (September 5, 2007)
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
eth1: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:17:08:2e:2e:f3
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth1: dma_rwctrl[763f0000] dma_mask[32-bit]

 tp->pci_chip_rev_id is 0x3003, which is ASIC_REV_5705.

-- 
dwmw2

