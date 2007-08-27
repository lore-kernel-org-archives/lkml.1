Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbXH0NLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbXH0NLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXH0NLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:11:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:33525 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbXH0NLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H3MDChsn91YvD3cQPyzEXJOVQE0/dOWCBCoMM2qsyy8kTJcIrHixNR0KdJED3DgZ4BG8rH8apPBrWFvcOso3HgwRJxFreUhI7ZuZT+nFauopyfbj7doEUnGZD9AXH8tV5TSfvbQ9hsgoRAO+jRQRjY5+jmDGPkCIMrepTT2e0WA=
Message-ID: <c70ff3ad0708270611x5598fa9dlc3afa5f6fabd6563@mail.gmail.com>
Date: Mon, 27 Aug 2007 16:11:10 +0300
From: "saeed bishara" <saeed.bishara@gmail.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
       akpm@linux-foundation.org, davem@davemloft.net,
       christopher.leech@intel.com, shannon.nelson@intel.com,
       herbert@gondor.apana.org.au, jeff@garzik.org
In-Reply-To: <20070627015155.18962.88413.stgit@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
	 <20070627015155.18962.88413.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

> +static dma_cookie_t
> +iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +
> +       old_chain_tail = list_entry(iop_chan->chain.prev,
> +               struct iop_adma_desc_slot, chain_node);
> +       list_splice_init(&sw_desc->group_list, &old_chain_tail->chain_node);
> +
> +       /* fix up the hardware chain */
> +       iop_desc_set_next_desc(old_chain_tail, grp_start->phys);
> +
