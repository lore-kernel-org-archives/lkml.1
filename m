Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYFBIT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYFBIT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758325AbYFBIS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:18:59 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:64729 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188AbYFBIS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:18:57 -0400
Date: Mon, 2 Jun 2008 10:11:02 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: benh@kernel.crashing.org, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080602101102.0d8979c5@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <Pine.LNX.4.64.0805301120510.26332@anakin>
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
	<20080530080700.773a82cc@siona.local>
	<1212132267.15633.69.camel@pasglop>
	<20080530102706.56fca248@siona.local>
	<Pine.LNX.4.64.0805301120510.26332@anakin>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2008 08:10:37.0926 (UTC) FILETIME=[24098860:01C8C488]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, 30 May 2008, Haavard Skinnemoen wrote:
> > Maybe we need another interface that does not do byteswapping but
> > provides stronger ordering guarantees?
> 
> The byte swapping depends on the device/bus.

Of course. But isn't it reasonable to assume that a device integrated
on the same silicon as the CPU is connected to a somewhat sane bus
which doesn't require any byte swapping?

> So what happened to the old idea of putting the accessor function pointers
> in the device/bus structure?

Don't know. I think it sounds like overkill to replace a simple load or
store with an indirect function call.

Haavard
