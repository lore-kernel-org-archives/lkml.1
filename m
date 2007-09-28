Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbXI1Woa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbXI1Woa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 18:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbXI1WoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 18:44:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47696
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757213AbXI1WoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:44:19 -0400
Date: Fri, 28 Sep 2007 15:44:19 -0700 (PDT)
Message-Id: <20070928.154419.94907210.davem@davemloft.net>
To: akepner@sgi.com
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [2/4] dma: redefine dma_flags_set_dmabarrier() for sn-ia64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070928011219.GO30013@sgi.com>
References: <20070928011219.GO30013@sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akepner@sgi.com
Date: Thu, 27 Sep 2007 18:12:19 -0700

> +static inline int dma_flags_set_dmabarrier(int dir) {
> +	return (dir | (DMA_BARRIER_ATTR<< DMA_ATTR_SHIFT));
> +}
> +
> +static inline int dma_flags_get_direction(int dir) {
> +	return (dir & DMA_DIR_MASK);
> +}
> +
> +static inline int dma_flags_get_dmabarrier(int dir) {
> +	return (((dir & DMA_ATTR_MASK) >> DMA_ATTR_SHIFT) & DMA_BARRIER_ATTR);
> +}

Coding style, put those openning braces on a line by themselves.
