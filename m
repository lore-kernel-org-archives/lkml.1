Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZINIDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZINIDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 04:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbZINIDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 04:03:16 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:58765 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZINIDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 04:03:15 -0400
Message-ID: <4AADF8C5.2000205@cfl.rr.com>
Date: Mon, 14 Sep 2009 04:03:17 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Mark Hounschell <markh@compro.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: problems doing direct dma from a pci device to pci-e device
References: <4AAA5B1F.3020103@compro.net> <20090911154714.70a94454@lxorguk.ukuu.org.uk> <4AAA6BE7.8040306@compro.net> <4AAAAD30.4040704@compro.net> <20090914053610.GA5970@lackof.org>
In-Reply-To: <20090914053610.GA5970@lackof.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Fri, Sep 11, 2009 at 04:04:00PM -0400, Mark Hounschell wrote:
>> A quick readup on the IOMMU makes me think that if it does use one, that
>> could certainly cause my problem. I'm using bus addresses plugged into
>> page tables that live in the gpiohsd card obtained from virt2bus.
> 
> If you haven't yet, take a look at Documentation/DMA-API.txt and
> DMA-mapping.txt . virt2bus has been deprecated for DMA since 2.4 releases.
> 
> grant
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

It still gives me a bus address just fine. Actually when the gpiohsd is dmaing
into another card I don't use it. I misspoke. The VMIC cards library API gives
me its memory's bus address.

Mark
