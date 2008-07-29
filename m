Return-Path: <linux-kernel-owner+w=401wt.eu-S1760524AbYG2Rnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524AbYG2Rnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbYG2RmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:42:19 -0400
Received: from cable-85.28.84.48.coditel.net ([85.28.84.48]:44269 "EHLO
	ibiza.bxl.tuxicoman.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759989AbYG2RmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:42:17 -0400
Date: Tue, 29 Jul 2008 19:42:12 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 64bit kernel not booting with CONFIG_PRINTK_TIME=y
Message-ID: <20080729194212.31a0a9f3@bleh.bxl.tuxicoman.be>
In-Reply-To: <20080729042929.GB11425@phobos.i.cabal.ca>
References: <20080717190502.74c238d5@bleh.bxl.tuxicoman.be>
	<20080719215459.GA2550@phobos.i.cabal.ca>
	<20080719230418.GA4263@phobos.i.cabal.ca>
	<20080720112345.07869299@bleh.bxl.tuxicoman.be>
	<20080729042929.GB11425@phobos.i.cabal.ca>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kyle,

Works like a charm !

ELF64 executable
Entry 00100000 first 00100000 n 3
Segment 0 load 00100000 size 5029888 mediaptr 0x1000
Segment 1 load 0063c000 size 395176 mediaptr 0x4cd000
Segment 2 load 006a0000 size 251456 mediaptr 0x52e000
Branching to kernel entry point 0x00100000.  If this is the last
message you see, you may need to switch your console.  This is
a common symptom -- search the FAQ and mailing list at parisc-linux.org

[17179569.184000] Linux version 2.6.27-rc1 (root@spiderman) (gcc version 4.2.4 (Gentoo 4.2.4 p1.0)) #1 SMP Tue Jul 29 19:32:01 CEST 2008
[17179569.184000] FP[0] enabled: Rev 1 Model 16
[17179569.184000] The 64-bit Kernel has started...
[17179569.184000] console [ttyB0] enabled
[17179569.184000] Initialized PDC Console for debugging.
[17179569.184000] Determining PDC firmware type: 64 bit PAT.


Thanks,
  Guy


On Tue, 29 Jul 2008 00:29:29 -0400
Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Sun, Jul 20, 2008 at 11:23:45AM +0200, Guy Martin wrote:
> > [    0.000000] FP[0] enabled: Rev 1 Model 16
> > [    0.000000] The 64-bit Kernel has started...
> 
> I pushed a better fix to my git tree on kernel.org on top of
> v2.6.27-rc1. Can you test that?
> 
> r, Kyle


-- 
Guy Martin
Gentoo Linux - HPPA port lead
