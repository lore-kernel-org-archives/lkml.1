Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZFDNMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZFDNMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZFDNMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:12:09 -0400
Received: from av8-1-sn3.vrr.skanova.net ([81.228.9.183]:38153 "EHLO
	av8-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbZFDNMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:12:07 -0400
X-Greylist: delayed 1139 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 09:12:07 EDT
Message-ID: <4A27C3B0.5000605@mocean-labs.com>
Date: Thu, 04 Jun 2009 14:53:04 +0200
From: =?UTF-8?B?UmljaGFyZCBSwprDtmpmb3Jz?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Added timbgpio
References: <4A262F54.3090106@mocean-labs.com> <20090604005119.6b4f80e0.akpm@linux-foundation.org>
In-Reply-To: <20090604005119.6b4f80e0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 03 Jun 2009 10:07:48 +0200 Richard R____jfors  <richard.rojfors.ext@mocean-labs.com> wrote:
> 
>> Supplied is a GPIO driver for the Timberdale FPGA found on the
>> Intel Atom board Russellville.
>>
>> ...
>>
>> +EXPORT_SYMBOL(timbgpio_gpio_flnk_lvl_ctrl);
>> +EXPORT_SYMBOL(timbgpio_gpio_int_ctrl);
>> +EXPORT_SYMBOL(timbgpio_gpio_lvl_ctrl);
>> +EXPORT_SYMBOL(timbgpio_gpio_int_clr);
> 
> Why all these module exports?

Internal stuff, I will remove it.

>> ...
>>
>> +config GPIO_TIMBERDALE
>> +	tristate "Support for timberdale GPIO"
>> +	depends on MFD_TIMBERDALE && GPIOLIB
>> +	---help---
>> +	Add support for GPIO usage of some pins of the timberdale FPGA.
>> +
> 
> I cannot find anything which sets MFD_TIMBERDALE anywhere?

Sorry, I realize I have to come back with a bigger patch set.

Timberdale is the MFD driver for the FPGA which among other expose this GPIO device.
This patch set will depend on patches in i2c-ocores and xilinx_spi which I have posted
earlier on the corresponding mailinglists.
Shall I repost those driver changes within this patch set, or can I leave them out?

--Richard
