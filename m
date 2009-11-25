Return-Path: <linux-kernel-owner+w=401wt.eu-S934800AbZKYSET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934800AbZKYSET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758829AbZKYSES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:04:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50851 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZKYSER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:04:17 -0500
Message-ID: <4B0D71A4.6090001@garzik.org>
Date: Wed, 25 Nov 2009 13:04:20 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 62/86] pata_pdc202xx_old: document known issues
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125174632.174666be@lxorguk.ukuu.org.uk> <4B0D6E62.3010609@garzik.org> <200911251852.40281.bzolnier@gmail.com>
In-Reply-To: <200911251852.40281.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 12:52 PM, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 25 November 2009 06:50:26 pm Jeff Garzik wrote:
>> On 11/25/2009 12:46 PM, Alan Cox wrote:
>>> On Wed, 25 Nov 2009 18:09:48 +0100
>>> Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>   wrote:
>>>
>>>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>>>> Subject: [PATCH] pata_pdc202xx_old: document known issues
>>>>
>>>> Document known issues with the driver to aid distribution makers,
>>>> users and developers in making informed decisions instead of wasting
>>>> their time needlessly.
>>>>
>>>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>>>> ---
>>>>    drivers/ata/Kconfig |    4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> Index: b/drivers/ata/Kconfig
>>>> ===================================================================
>>>> --- a/drivers/ata/Kconfig
>>>> +++ b/drivers/ata/Kconfig
>>>> @@ -583,6 +583,10 @@ config PATA_PDC_OLD
>>>>    	  This option enables support for the Promise 20246, 20262, 20263,
>>>>    	  20265 and 20267 adapters.
>>>>
>>>> +	  Known issues:
>>>> +	  - UDMA transfers fail mysteriously on some chipsets
>>>> +	  - ATAPI DMA is unsupported currently
>>>
>>> Not sure this is useful, because the reports of UDMA failures are lower
>>> than most other reports. Should IPV6 have "known issues, mysterious timer
>>> list corruption" for example which occurs far more. Not do we list 'no
>>> atapi dma' in the help for the IDE SII driver ?
>>
>> If the chip can support ATAPI DMI, but the driver does not, that
>> deserves a comment, even if it's "hardware bugs prevent ATAPI DMA" or
>> "ATAPI DMA would require much more code to support, so we did not bother
>> for now"
>>
>> Ditto for things like useful ideas ("consider PIO-over-DMA in SiI 311x")
>> and other would-be-nice-to-have ideas.  These can serve as projects for
>> newbies, or reminders for old-timers.
>
> The problem is that the old driver supported ATAPI DMA so people may have
> quite different expectations than in case of never-ever-implemented-ideas.

This is not rocket science :)  Have one section "known issues" and 
another section "fun ideas to explore."  This is English code comments, 
you may set any level of expectations.

	Jeff



