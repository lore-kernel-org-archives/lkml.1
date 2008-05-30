Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbYE3GHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbYE3GHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYE3GHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:07:43 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:37193 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYE3GHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:07:42 -0400
Date: Fri, 30 May 2008 08:07:00 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: benh@kernel.crashing.org
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080530080700.773a82cc@siona.local>
In-Reply-To: <1212110003.15633.0.camel@pasglop>
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
	<1212110003.15633.0.camel@pasglop>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2008 06:07:00.0425 (UTC) FILETIME=[5F9F7390:01C8C21B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 11:13:23 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> > Currently, this is the only interface I know that can do native-endian
> > accesses, so if you take it away, I'm gonna need an alternative
> > interface that doesn't do byteswapping.  
> 
> Are you aware that these also don't provide any ordering guarantee ?

Yes, but I am not aware of any alternative.

I think the drivers I've written have the necessary barriers (or dma
ops with implicit barriers) that they don't actually depend on any
DMA vs. MMIO ordering guarantees. I hope MMIO vs. MMIO ordering is
guaranteed though?

Haavard
