Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbXEJLRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbXEJLRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXEJLRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:17:12 -0400
Received: from mx1.cdac.in ([203.199.132.35]:4710 "EHLO mx1.cdac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbXEJLRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:17:11 -0400
Message-ID: <4642FFA7.4040303@cdac.in>
Date: Thu, 10 May 2007 16:49:03 +0530
From: Mahesh <maheshk@cdac.in>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
Subject: Re: [HOWTO] accessing the DMA mapped data
References: <4642D095.6070305@cdac.in> 
	<20070510.014751.74749340.davem@davemloft.net>
In-Reply-To: <20070510.014751.74749340.davem@davemloft.net>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-imss-version: 2.046
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:3.6.1039(15166.003)
X-imss-scores: Clean:80.46452 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:2 C:1 M:1 S:1 R:1 (0.1500 0.1500)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miller,

Thanks for replying.
> You can eithe keep track of this yourself, or (depending upon
> your usage) you might be able to use DMA pools, see
> dma_pool_create() and friends.
>   
I think you have not understood my question properly. My problem is, the 
layer above the driver will do
dma_map_single on a kmalloc'ed buffer and passes the result  (bus 
address) to the device driver. Now
the driver has to modify the contents of the the original buffer.
Is it possible to do that ??

-regards,
Mahesh

