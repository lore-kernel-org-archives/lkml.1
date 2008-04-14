Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbYDNT0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbYDNT0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbYDNT0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:26:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57964 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752576AbYDNT0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:26:31 -0400
Date: Mon, 14 Apr 2008 20:16:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080414201639.799770f4@core>
In-Reply-To: <1208195673.7164.2.camel@twins>
References: <20080411210022.GJ11962@parisc-linux.org>
	<1208003081.7427.7.camel@twins>
	<20080412172606.GL11962@parisc-linux.org>
	<adaskxqrgsl.fsf@cisco.com>
	<20080412204748.GN11962@parisc-linux.org>
	<20080413070833.GC19773@elte.hu>
	<20080413125758.GQ11962@parisc-linux.org>
	<20080414153928.GA22259@elte.hu>
	<adafxtoqvgh.fsf@cisco.com>
	<1208190749.7375.10.camel@twins>
	<87d4osuy6r.fsf@basil.nowhere.org>
	<1208195673.7164.2.camel@twins>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Because we can then eventually get rid of semaphores, so those people
> cannot mistakenly use them. Its just too easy to create prio inversion
> with them around.

And it'll be far harder to even find the priority inversion problems in
the open coded alternatives.
