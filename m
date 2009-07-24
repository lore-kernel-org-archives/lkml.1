Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZGXOKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZGXOKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZGXOKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:10:23 -0400
Received: from relay.atmel.no ([80.232.32.139]:59358 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZGXOKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:10:23 -0400
Date: Fri, 24 Jul 2009 16:10:01 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: nicolas.ferre@atmel.com, dan.j.williams@intel.com,
       maciej.sosnowski@intel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
Message-ID: <20090724161001.412e0199@siona>
In-Reply-To: <20090724.222919.240484146.anemo@mba.ocn.ne.jp>
References: <1248285885-1189-1-git-send-email-nicolas.ferre@atmel.com>
	<e9c3a7c20907231013k3d5e8c89w1069e8509539438f@mail.gmail.com>
	<4A696449.7050303@atmel.com>
	<20090724.222919.240484146.anemo@mba.ocn.ne.jp>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 22:29:19 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> > The patches for adaptation of atmel-mci to at_hdmac are coming...  
> 
> Your atc_chain_complete() calls dma_unmap_xxx unless
> DMA_COMPL_SKIP_XXX_UNMAP specified.  But atmel-mci driver does not set
> the flag on dma_async_tx_descriptor.  I suppose one of them should be
> fixed.

atmel-mci should definitely set that flag.

Haavard
