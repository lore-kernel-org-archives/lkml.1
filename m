Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0CCGg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:36:58 -0500
Received: from sh.osrg.net ([192.16.179.4]:35044 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab0CCGg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:36:56 -0500
Date: Wed, 3 Mar 2010 15:35:48 +0900
To: benh@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, catalin.marinas@arm.com,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org,
       linux@arm.linux.org.uk, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, santosh.shilimkar@ti.com,
       pavel@ucw.cz, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1267593032.16696.1.camel@pasglop>
References: <1267572594.2173.25.camel@pasglop>
	<20100303124624Z.fujita.tomonori@lab.ntt.co.jp>
	<1267593032.16696.1.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100303153437E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 03 Mar 2010 15:35:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Mar 2010 16:10:32 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2010-03-03 at 12:47 +0900, FUJITA Tomonori wrote:
> > The ways to improve the approach (introducing PG_arch_2 or marking a
> > page clean on dma_unmap_* with DMA_FROM_DEVICE like ia64 does) is up
> > to architectures. 
> 
> How does the above work ? IE, the dma unmap will flush the D side but
> not the I side ... or is the ia64 flush primitive magic enough to do
> both ?

On ia64 platform, I (and D) cache is coherent with the memory that you
did DMA to, I think. But better to ask an ia64 guru. :)
