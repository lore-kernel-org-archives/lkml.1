Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbYE3JWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbYE3JWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYE3JWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:22:33 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:54611 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYE3JWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:22:32 -0400
Date: Fri, 30 May 2008 11:22:19 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
cc: benh@kernel.crashing.org, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <20080530102706.56fca248@siona.local>
Message-ID: <Pine.LNX.4.64.0805301120510.26332@anakin>
References: <1211852026.3286.36.camel@pasglop> <20080526.184047.88207142.davem@davemloft.net>
 <1211854540.3286.42.camel@pasglop> <20080526.192812.184590464.davem@davemloft.net>
 <1211859542.3286.46.camel@pasglop> <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
 <1211922621.3286.80.camel@pasglop> <alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org>
 <1211924335.3286.89.camel@pasglop> <20080527214241.GA22636@parisc-linux.org>
 <1211926636.3286.100.camel@pasglop> <20080528103648.54eb8734@hskinnemo-gx745.norway.atmel.com>
 <1212110003.15633.0.camel@pasglop> <20080530080700.773a82cc@siona.local>
 <1212132267.15633.69.camel@pasglop> <20080530102706.56fca248@siona.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Haavard Skinnemoen wrote:
> Maybe we need another interface that does not do byteswapping but
> provides stronger ordering guarantees?

The byte swapping depends on the device/bus.

So what happened to the old idea of putting the accessor function pointers
in the device/bus structure?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
