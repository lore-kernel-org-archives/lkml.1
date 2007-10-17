Return-Path: <linux-kernel-owner+w=401wt.eu-S936217AbXJQD2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936217AbXJQD2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXJQD2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:28:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbXJQD2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:28:44 -0400
Date: Tue, 16 Oct 2007 20:27:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dma: add dma_flags_set/get_*() interfaces
Message-Id: <20071016202728.81450e25.akpm@linux-foundation.org>
In-Reply-To: <20071017014128.GJ5601@sgi.com>
References: <20071017014128.GJ5601@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 18:41:28 -0700 akepner@sgi.com wrote:

> +#define DMA_BARRIER_ATTR	0x1
> +#ifndef ARCH_USES_DMA_ATTRS
> +static inline int dma_flags_set_attr(u32 attr, enum dma_data_direction dir) 
> +{
> +	return dir;
> +}

This function takes an `enum dma_data_direction' as its second arg, but your
ia64 implementation takes an 'int'.

> +static inline int dma_flags_get_dir(int flags)
> +{
> +	return flags;
> +}
> +
> +static inline int dma_flags_get_attr(int flags)
> +{
> +	return 0;
> +}


