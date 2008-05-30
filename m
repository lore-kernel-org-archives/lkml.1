Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYE3BOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYE3BOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYE3BN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:13:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:49071 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbYE3BN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:13:58 -0400
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
In-Reply-To: <20080528103648.54eb8734@hskinnemo-gx745.norway.atmel.com>
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
Content-Type: text/plain
Date: Fri, 30 May 2008 11:13:23 +1000
Message-Id: <1212110003.15633.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I do -- in all the drivers for on-chip peripherals that are shared
> between AT91 ARM (LE) and AVR32 (BE). Since everything goes on inside
> the chip, we must use LE accesses on ARM and BE accesses on AVR32.
> 
> Currently, this is the only interface I know that can do native-endian
> accesses, so if you take it away, I'm gonna need an alternative
> interface that doesn't do byteswapping.

Are you aware that these also don't provide any ordering guarantee ?

Ben.


