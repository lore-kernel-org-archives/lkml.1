Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYIDSIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYIDSIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYIDSIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:08:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36654 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752702AbYIDSIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:08:45 -0400
Date: Thu, 4 Sep 2008 19:07:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080904190728.59634020@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de>
	<20080904153620.GC7120@elte.hu>
	<alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
	<20080904160036.GA18382@elte.hu>
	<alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (And yes, I do the latching - it's not reqlly required since I only depend 
> on the MSB, and it actually makes for slightly lower precision, but it's 
> the "safe" thing. And I figured out that the reason I thought that the 

Good job you don't. Various Cyrix/Geode chipsets have as errata #2

"Counter latch command is non-operational in the 8254 timer"

Alan
