Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYGDIzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYGDIzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 04:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYGDIy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 04:54:59 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64242 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYGDIy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 04:54:58 -0400
Message-ID: <486DE551.8070301@atmel.com>
Date: Fri, 04 Jul 2008 10:54:41 +0200
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: VILCHEZ Patrice <Patrice.VILCHEZ@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Support for the at91sam9g20 : Atmel 400Mhz ARM 926ej-s
 SOC
References: <4852324C.9000604@atmel.com> <20080703133244.GB17201@flint.arm.linux.org.uk> <486CDFE5.9030105@atmel.com> <20080703165505.GT17201@flint.arm.linux.org.uk>
In-Reply-To: <20080703165505.GT17201@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,

Russell King - ARM Linux a écrit :
> On Thu, Jul 03, 2008 at 04:19:17PM +0200, Sedji Gaouaou wrote:
>> Hi Andrew,
>>>   
>>>> +/*
>>>> + * MCI (SD/MMC)
>>>> + */
>>>> +static struct at91_mmc_data __initdata ek_mmc_data = {
>>>> +	.slot_b		= 1,
>>>> +	.wire4		= 1,
>>>> +//	.det_pin	= ... not connected
>>>> +//	.wp_pin		= ... not connected
>>>> +//	.vcc_pin	= ... not connected
>>>>     
>>> Please make these a proper comment, preferably inside the comment before
>>> the structure.  C++ comments are frowned upon in the kernel's source.
>>
>> I would like to know what do you suggest about this comment? Indeed we 
>> already use this kind of comments, for instance in board-sam9260ek.c. I 
>> don't mind changing it into the proper comment form, but I would like to 
>> know first what do you suggest.
> 
> Documentation/CodingStyle:
> |
> |                Chapter 8: Commenting
> |
> ...
> |
> |Linux style for comments is the C89 "/* ... */" style.
> |Don't use C99-style "// ..." comments.
> 
> So how about:
> 
> /*
>  * MCI (SD/MMC)
>  * det_pin, wp_pin and vcc_pin are not connected
>  */
> static struct at91_mmc_data __initdata ek_mmc_data = {
> 	.slot_b         = 1,
> 	.wire4          = 1,
> };
> 
It is fine for me, I will change the patch with the proper style for 
comments.
BTW I have found the problem in the patch on the patch system, so I will 
change that too.
Thank you for your help and comments.

Regards,
Sedji

