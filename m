Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbXEJIr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbXEJIr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbXEJIrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:47:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37992
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757304AbXEJIrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:47:48 -0400
Date: Thu, 10 May 2007 01:47:51 -0700 (PDT)
Message-Id: <20070510.014751.74749340.davem@davemloft.net>
To: maheshk@cdac.in
Cc: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
Subject: Re: [HOWTO] accessing the DMA mapped data
From: David Miller <davem@davemloft.net>
In-Reply-To: <4642D095.6070305@cdac.in>
References: <4642D095.6070305@cdac.in>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh <maheshk@cdac.in>
Date: Thu, 10 May 2007 13:28:13 +0530

> I have a small question regarding the accessing the data in the DMA 
> mapped  region (in the driver).  In my driver I only have the 
> 'dma_addr_t addr' variable which is result after the 'dma_map_single'. 
> I don't have access to the virtual address of the data region.
> 
> Is there helper routine which we will give me the virtual address back 
> from the DMA mapped address???

You can eithe keep track of this yourself, or (depending upon
your usage) you might be able to use DMA pools, see
dma_pool_create() and friends.
