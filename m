Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZIQNgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZIQNgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbZIQNgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:36:48 -0400
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:43997 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZIQNgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:36:47 -0400
Date: Thu, 17 Sep 2009 09:36:46 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [PULL] http://www.kernellabs.com/hg/~stoth/saa7164-merge
In-reply-to: <20090917100258.2a5269d9@pedra.chehab.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4AB23B6E.6050001@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4AA08B01.30705@kernellabs.com>
 <20090917100258.2a5269d9@pedra.chehab.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.1)
 Gecko/20090715 Thunderbird/3.0b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/09 9:02 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 03 Sep 2009 23:35:29 -0400
> Steven Toth<stoth@kernellabs.com>  escreveu:
>
>> Hello Mauro,
>>
>> This patch series adds support for the NXP SAA7164 PCIe A/V bridge used by the
>> Hauppauge HVR-2200 and HVR-2250 series of products. Support is limited to DVB-T
>> / ATSC / QAM digital TV only. The driver has been in development (on and off)
>> for around a year and the KernelLabs saa7164-stable tree (from which this patch
>> set was prepared) has been in testing worldwide since approx May(?) 2009.
>>
>> The project page including links for firmware downloads, MythTV and Wiki
>> instructions is here: http://www.kernellabs.com/blog/?page_id=17
>>
>> Two general observations with the tree:
>>
>> 1. The driver is a little verbose during initial module load, I need to trim a
>> few lines of debug.
>> 2. During 64bit compile I have one compile time warning to be addressed.
>>
>> Both of these will be resolved shortly and should not stop the driver being
>> merged and made available to a much wider range of testers.
>>
>> So, please pull from http://www.kernellabs.com/hg/~stoth/saa7164-merge
>
>> SAA7164: Fix i2c eeprom read errors during load (some boards).
>> From: Steven Toth<stoth@kernellabs.com>
>> SAA7164: Fix i2c eeprom read errors during load (some boards).
>> Priority: normal
>> Signed-off-by: Steven Toth<stoth@kernellabs.com>
>
> Please don't repeat the one-line summary as description. There are several cases like the above.
>
>>      -  Add the SAA7164 I2C bus identifier
>
> --- a/linux/include/linux/i2c-id.h      Thu Sep 03 09:06:34 2009 -0300
> +++ b/linux/include/linux/i2c-id.h      Sat May 09 12:24:12 2009 -0400
>
> +#define I2C_HW_B_SAA7164        0x010024 /* NXP 7164 based tv cards */
>
> Why? Are you needing to use this constant somewhere? If not, just drop it and
> leave the field in blank.
>
> Anyway, I won't delay applying it due to that. I'm committing the series. Please send a fix
> later for the i2c-id above mentioned.

Thanks.

I should go back and check the other trees, if this field isn't required by the 
i2c sub-system then I can remove it from a number of drivers. Of course, this 
tree is fairly old and it may have already been done in the 23885 / cx88 / 
au0828 tree's by the other devs. I'll look into this.

Regardless, I'll generate the i2c patch.

I also have another 2.6.31 related patch stacked up, once mkrufky's tree is also 
merged. I'll issue both of these for merge later today.

Thanks again,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
