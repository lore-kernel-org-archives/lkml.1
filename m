Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbXEOHeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbXEOHeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbXEOHeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:34:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:40443 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbXEOHeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:34:37 -0400
Subject: Re: [patch 4/4] powerpc 2.6.21-rt1: reduce scheduling latency by
	changing tlb flush size
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <yyir6pi67yd.wl@toshiba.co.jp>
References: <yyi3b1zapqa.wl@toshiba.co.jp>
	 <1179125506.22481.297.camel@localhost.localdomain>
	 <yyitzuf9857.wl@toshiba.co.jp> <200705141640.02561.arnd@arndb.de>
	 <yyir6pi67yd.wl@toshiba.co.jp>
Content-Type: text/plain
Date: Tue, 15 May 2007 17:34:12 +1000
Message-Id: <1179214452.32247.170.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 13:12 +0900, Tsutomu OWA wrote:

> > With this code, you get silent side-effects of enabling PPC_CELLEB
> > along with another platform.
> 
>   Yeah, thank you for pointing it out.
>   I'll send revised patch later.
> 
> > Maybe instead you should change the hpte_need_flush() to always flush
> > when running on the celleb platform and PREEMPT_RT is enabled.
> 
>   Hmm... Is it in linux-2.6.21?  grep'ing it did not help... 
> 
>   Is http://patchwork.ozlabs.org/linuxppc/patch?id=10361 is the first place
> where the hpte_need_flush() appears?

Yes, I added that when reworking the batching mecanism.

Ben.


