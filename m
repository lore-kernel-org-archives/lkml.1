Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZFXHXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZFXHXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZFXHXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:23:48 -0400
Received: from mail.atmel.fr ([81.80.104.162]:49142 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZFXHXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:23:47 -0400
Message-ID: <4A41D470.3070507@atmel.com>
Date: Wed, 24 Jun 2009 09:23:28 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-usb@vger.kernel.org, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org, david-b@pacbell.net,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3 v3] at91/USB: Add USB gadget driver selection for
 at91sam9g45 series
References: <200906190045.16496.david-b@pacbell.net> <6af1745bf0de30efbd68addd05c2670311c7743a.1245775871.git.nicolas.ferre@atmel.com> <20090623212937.GO23512@game.jcrosoft.org>
In-Reply-To: <20090623212937.GO23512@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Christophe PLAGNIOL-VILLARD :
> On 18:58 Tue 23 Jun     , Nicolas Ferre wrote:
>> Add gadget USB drivers for at91sam9g45 series. Those SOC include
>> high speed USB interfaces.
>> The gadget driver is the already available atmel_usba_udc.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> v2 -> v3: split patch to:
>> - gadget
>> - ohci
>> - ehci
>>
>>  drivers/usb/gadget/Kconfig |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
>> index 080bb1e..9beea52 100644
>> --- a/drivers/usb/gadget/Kconfig
>> +++ b/drivers/usb/gadget/Kconfig
>> @@ -124,7 +124,7 @@ choice
>>  
>>  config USB_GADGET_AT91
>>  	boolean "Atmel AT91 USB Device Port"
>> -	depends on ARCH_AT91 && !ARCH_AT91SAM9RL && !ARCH_AT91CAP9
>> +	depends on ARCH_AT91 && !ARCH_AT91SAM9RL && !ARCH_AT91CAP9 && !ARCH_AT91SAM9G45
> same as ATMEL_FB
> it will be really better to define it at the soc level

No, I do not think this is relevant here.

For now, only 4 dependency on a line is totally acceptable. The cost of
the adding of a new configuration variable is too high in this case
(readability, simplicity, ease of use, etc.).

Best regards,
-- 
Nicolas Ferre

