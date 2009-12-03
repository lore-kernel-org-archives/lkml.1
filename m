Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZLCWGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZLCWGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZLCWGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:06:51 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:28086 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751605AbZLCWGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:06:50 -0500
Message-ID: <4B183671.80004@ru.mvista.com>
Date: Fri, 04 Dec 2009 01:06:41 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_it8213: MWDMA0 is unsupported
References: <200911261728.36433.bzolnier@gmail.com> <200911261800.55025.bzolnier@gmail.com> <4B0EB986.2010801@ru.mvista.com> <4B1827EA.4050608@garzik.org>
In-Reply-To: <4B1827EA.4050608@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

>>>> MWDMA0 timings cannot be met with the PIIX based controller
>>>> programming interface.
>>
>>>> This change should be safe as this is how we have been doing
>>>> things in IDE it8213 host driver for years.
>>
>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>> ---
>>>> Verified with the documentation (similar case as with pata_efar).
>>
>>> Uhhh, no...
>>
>>> Too many damn drivers.
>>
>>> Too much damn duplication.
>>
>>> Too much damn subtle differences here and there.
>>
>>> The hardware is probably fine for MWMDA0 when it comes to
>>> pata_{efar,it8213},
>>> it just not documented properly in the data sheet.
>>
>> How so with pata_efar? The active/recovery bitfields are still 2-bit
>> wide, no?
>
> So....  pata_it8213 is fine for MWDMA0, then?

   No, TTBOMK. I just have no datasheet. However, it's programmed 
overclocked and even in theory the cycle time cannot exceeed 600 ns vs 
480 ns spec'ed.

>     Jeff

MBR, Sergei


