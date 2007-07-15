Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbXGOJhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbXGOJhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbXGOJhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:37:23 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42538
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672AbXGOJhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:37:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bryan.wu@analog.com
Subject: Re: [PATCH 1/3] Blackfin ethernet driver: on chip ethernet MAC controller driver
Date: Sun, 15 Jul 2007 11:36:04 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <1184438993.3140.23.camel@roc-laptop> <200707142138.36619.mb@bu3sch.de> <1184491016.3140.52.camel@roc-laptop>
In-Reply-To: <1184491016.3140.52.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707151136.05223.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2007 11:16:56 Bryan Wu wrote:
> In current Blackfin DMA allocation/free, the return value from 
> bfin_mac_alloc() is used as the dma_handle, here it is the
> tx_desc/rx_desc. 
> The "dma_handle" is useless in the following code.

I think a comment has to be added, at least, as it's very confusing.

> This is some magic code for PHY ID. In the future, we will rewrite some
> code based on kernel phy abstraction layer to support more phy device.

Ok, nice idea.

> > Unwind the allocations above, if registering fails.
> > 
> 
> In fact, it is safe. Because if registering fails, bf537mac_probe will
> return none zero to bfin_mac_probe which will do free_netdev.

Hm, weren't there some DMA allocations, too? Are they free'd properly?

-- 
Greetings Michael.
