Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbYDXMZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbYDXMZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYDXMYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:24:50 -0400
Received: from araneidae.co.uk ([62.3.233.233]:1468 "EHLO mail.araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbYDXMYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:24:50 -0400
Date: Thu, 24 Apr 2008 12:24:43 +0000 (GMT)
From: Michael Abbott <michael@araneidae.co.uk>
To: Ben Dooks <ben-linux@fluff.org>
cc: Daniel Mack <daniel@caiaq.org>, linux-arm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Colibri: Fix support for DM9000 ethernet device.
In-Reply-To: <20080424112858.GD16284@fluff.org.uk>
Message-ID: <20080424122203.B52164@saturn.araneidae.co.uk>
References: <20080424095917.Q51356@saturn.araneidae.co.uk>
 <20080424112858.GD16284@fluff.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Ben Dooks wrote:
> On Thu, Apr 24, 2008 at 10:13:09AM +0000, Michael Abbott wrote:
>> From: Michael Abbott <michael.abbott@diamond.ac.uk>
>>
>> Colibri: Fix support for DM9000 ethernet device.
>> diff --git a/arch/arm/mach-pxa/colibri.c b/arch/arm/mach-pxa/colibri.c
>> --- a/arch/arm/mach-pxa/colibri.c
>> +++ b/arch/arm/mach-pxa/colibri.c
>> @@ -118,7 +118,7 @@ static void __init colibri_init(void)
>>  	/* DM9000 LAN */
>>  	pxa_gpio_mode(GPIO78_nCS_2_MD);
>>  	pxa_gpio_mode(GPIO_DM9000 | GPIO_IN);
>> -	set_irq_type(COLIBRI_ETH_IRQ, IRQT_FALLING);
>> +	set_irq_type(COLIBRI_ETH_IRQ, IRQT_RISING);
>
> The set_irq_type() call here should be removed.

I can confirm that Ben is right, and that the set_irq_type call can be 
removed.

What is the procedure here?  Do I submit a new patch to supersede the old 
one?
