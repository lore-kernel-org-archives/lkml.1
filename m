Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZFHS7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZFHS7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZFHS7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:59:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:23575 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZFHS7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <c8284b5b0906080958o65a97a8dm914aa8b4c6e7a821@mail.gmail.com>
References: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>
	 <4A1FFEFB.6050104@drewtech.com>
	 <c8284b5b0906020953o7c112b4hc264b5520cc3aed1@mail.gmail.com>
	 <4A269251.8090706@atmel.com> <4A269A83.3020008@drewtech.com>
	 <c8284b5b0906031202u18433b52s1a0718ef627fddf0@mail.gmail.com>
	 <20090608124719.7c36840b@hskinnemoen-d830>
	 <c8284b5b0906080958o65a97a8dm914aa8b4c6e7a821@mail.gmail.com>
Date: Mon, 8 Jun 2009 11:59:06 -0700
X-Google-Sender-Auth: 9b7da846ba6855fb
Message-ID: <c8284b5b0906081159k2dc03216qcf2aa224fa06d0be@mail.gmail.com>
Subject: Re: [PATCH][Updated] New AT91 MCI Driver that supports both MCI slots 
	used at the same time
From: Rob Emanuele <poorarm@shoreis.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Joey Oravec <joravec@drewtech.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard,

I'll revise my previous thought about integrating my changes back into
the Atmel driver.  I'll start that today.  I figure this way, the
changes I make can get in front of a wider audience.

Thanks,

Rob

On Mon, Jun 8, 2009 at 9:58 AM, Rob Emanuele<poorarm@shoreis.com> wrote:
> Hi Haavard,
>
> I'd be happy to reintegrate my changes to this back into the Atmel
> driver once I get it working correct on the at91.  Do you have the
> equipment to give my changes a try?
>
> Converting my #defines for the the features to cpu_is_xxx is easy
> enough.  I'll take care of that.
>
> Thanks,
>
> Rob
>
> On Mon, Jun 8, 2009 at 3:47 AM, Haavard
> Skinnemoen<haavard.skinnemoen@atmel.com> wrote:
>> Rob Emanuele wrote:
>>> This driver is a port the Atmel AVR32 MCI driver which uses similar silicon.
>>
>> While I do understand the motivation for this patch, I was kind of
>> hoping we could reduce the number of drivers for the Atmel MCI
>> hardware, not increase it...
>>
>> So I think it would be much better if your changes were integrated into
>> one of the existing drivers.
>>
>>> Joey Oravec has mentioned that he has had better reliability with the chip
>>> he is using (AT91SAM9261) if the MMC controller is reset before each
>>> command.  There is a compile time option to do just that.
>>
>> This could be a useful option for atmel-mci too.
>>
>>> Joey Oravec has stated that the Read and Write Proof functionality that
>>> prevents buffer overflows is not available on the AT91SAM9261.  This was
>>> confirmed by Nicolas Ferre and also affects the AT91RM9200.  This new
>>> patch excludes those register config bits.
>>
>> Preferably use the cpu_is_xxx() functions to achieve that. Perhaps even
>> wrap those tests inside a mci_has_xxproof() function to make it
>> clearer what you're testing for, and easier to change if we decide to
>> do the test based on version registers, etc. later.
>>
>> Haavard
>>
>
