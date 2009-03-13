Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbZCMBDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbZCMBDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZCMBCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:02:51 -0400
Received: from mail.renesas.com ([202.234.163.13]:41107 "EHLO
	mail03.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754139AbZCMBCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:02:50 -0400
X-AuditID: ac140386-0000000700001aa8-63-49b9b0b21bdc
Date: Fri, 13 Mar 2009 10:02:41 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: Re: [PATCH] dmaengine: sh: Add support DMA-Engine driver for DMA of
 SuperH
In-reply-to: <20090312112231.GE1475@console-pimps.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux-sh <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com,
       Paul Mundt <lethal@linux-sh.org>
Message-id: <49B9B0B1.6020703@renesas.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=UTF-8
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
References: <49B8AF67.8080309@renesas.com>
 <20090312112231.GE1475@console-pimps.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matt.

Thank you for your review.

Matt Fleming wrote:
> On Thu, Mar 12, 2009 at 03:44:55PM +0900, Nobuhiro Iwamatsu wrote:
>> This supports DMA-Engine driver for DMA of SuperH.
>> This supported all DMA channels, and it was tested in SH7722/SH7780.
>> This can not use with SH DMA API and can control this in Kconfig.
>>
> 
> I was working on support for this, but fortunately for me you beat me
> to a finished implementation ;-)
> 
> The code looks good to me. Just a few (very very) minor nits.
> 
> Reviewed-by: Matt Fleming <matt@console-pimps.org>
> 
> [...]
> 
>> +/* for dma engine */
>> +/* mode */
>> +#define SHDMA_MIX_IRQ	(1 << 1)
> 
> The proper multi-line kernel comment style is
> 
> 	/*
> 	 *
> 	 */
> 
> though this comment can all fit on one line.
> 
OK, I fix it.
>> +
>> +static void dmae_init(struct sh_dmae_chan *sh_chan)
>> +{
>> +	u32 chcr = RS_DEFAULT; /* default is DUAL mode */
>> +	sh_dmae_writel(sh_chan, chcr, CHCR);
>> +}
>> +
>> +/*
>> + * Reset DMA controler
> 
> controler -> controller
> 
Oops, thank you.

I fix your check point and resend patch.

Best regards,
  Nobuhiro
