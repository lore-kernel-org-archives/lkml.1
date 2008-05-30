Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbYE3HZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbYE3HZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYE3HZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:25:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:37022 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbYE3HZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:25:41 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
In-Reply-To: <20080530080700.773a82cc@siona.local>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <1211859542.3286.46.camel@pasglop>
	 <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
	 <1211922621.3286.80.camel@pasglop>
	 <alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org>
	 <1211924335.3286.89.camel@pasglop>
	 <20080527214241.GA22636@parisc-linux.org>
	 <1211926636.3286.100.camel@pasglop>
	 <20080528103648.54eb8734@hskinnemo-gx745.norway.atmel.com>
	 <1212110003.15633.0.camel@pasglop>  <20080530080700.773a82cc@siona.local>
Content-Type: text/plain
Date: Fri, 30 May 2008 17:24:27 +1000
Message-Id: <1212132267.15633.69.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-30 at 08:07 +0200, Haavard Skinnemoen wrote:
> On Fri, 30 May 2008 11:13:23 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > > Currently, this is the only interface I know that can do native-endian
> > > accesses, so if you take it away, I'm gonna need an alternative
> > > interface that doesn't do byteswapping.  
> > 
> > Are you aware that these also don't provide any ordering guarantee ?
> 
> Yes, but I am not aware of any alternative.
> 
> I think the drivers I've written have the necessary barriers (or dma
> ops with implicit barriers) that they don't actually depend on any
> DMA vs. MMIO ordering guarantees. I hope MMIO vs. MMIO ordering is
> guaranteed though?

Only to the same address I'd say.

Ben.


