Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYISPI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYISPI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYISPIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:08:22 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:64502 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYISPIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:08:21 -0400
Message-ID: <48D3BEB2.3060902@freescale.com>
Date: Fri, 19 Sep 2008 10:01:06 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
References: <48D02589.8070601@freescale.com> <e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com> <ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com> <20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com> <48D2664D.7040204@freescale.com> <20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com> <e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com> <20080919132544.533ab7d0@hskinnemo-gx745.norway.atmel.com> <48D3B880.3070607@freescale.com> <Pine.LNX.4.61.0809191042020.11905@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0809191042020.11905@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) wrote:
> On Fri, 19 Sep 2008, Timur Tabi wrote:
> 
>> Haavard Skinnemoen wrote:
>>
>>> Yes, or maybe provide an interface for simply requesting a channel
>>> without having to register any callbacks.
>> I could use this feature.  The sound drivers for our MPC8610 processor use DMA,
>> but the drivers need to control the DMA hardware directly, so I can't use
>> dmaengine.  I would like to be able to just reserve the channels and program
>> them as I see fit.
>>
>> -- 
>> Timur Tabi
>> Linux kernel developer at Freescale
> 
> The hardware on the PC/AT machines won't allow you to
> reserve a specific channel and program it as you see fit,
> because there are two devices, one for the low DMA
> channels and another for the high ones. 

True, but that restriction doesn't apply to all processors.  So we could still
provide the capability of reserving channels for those systems where it makes
sense.  This is the case for the DMA controller I'm working with.

My solution for now is to permanently reserve the channels I need.  This is safe
and probably okay, because there are 6 other channels still available.  However,
if there was a mechanism where I could dynamically reserve channels, I would use it.

> The information transmitted in this message is confidential and may be privileged. 

Really?

-- 
Timur Tabi
Linux kernel developer at Freescale
