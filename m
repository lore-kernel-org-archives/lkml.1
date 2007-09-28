Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbXI1WoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbXI1WoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 18:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbXI1WoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 18:44:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57671
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753642AbXI1WoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:44:00 -0400
Date: Fri, 28 Sep 2007 15:43:59 -0700 (PDT)
Message-Id: <20070928.154359.66076641.davem@davemloft.net>
To: akepner@sgi.com
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [1/4] dma: add dma_flags_set_dmabarrier() to dma interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070928011059.GN30013@sgi.com>
References: <20070928011059.GN30013@sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akepner@sgi.com
Date: Thu, 27 Sep 2007 18:10:59 -0700

> +#ifndef ARCH_CAN_REORDER_DMA
> +static inline int dma_flags_set_dmabarrier(int dir) {
> +	return dir;
> +}
> +#endif /* ARCH_CAN_REORDER_DMA */

Coding style, that initial openning brace should be
on a line by itself.
