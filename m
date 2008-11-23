Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYKWWYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYKWWYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYKWWYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:24:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:52703 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYKWWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:24:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=CuKDJGRyWYJde5SKQK/bo2vKu8dhVpDgdE8hxgLYj8VLehN8fuQrvpWbosKl7sxJYL
         y8vzuA1Ff/5EE/DU5pXJeEO0DVm7PYIhM5P/Qyr1b7zeGKdAv0wCrGESPBx97mCq3maM
         dc9RGvsLqJpEbIU5PrnvA3op3VHI4o3nRAWCA=
Message-ID: <4929D803.80708@tuffmail.co.uk>
Date: Sun, 23 Nov 2008 22:24:03 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Linux 2.6.27-git3: no SD card reader
References: <20081014025453.617f2ef8@werewolf.home>	<20081014174536.1353d17e@mjolnir.drzeus.cx>	<20081014232759.08f5d212@werewolf.home> <20081123213921.667ecb93@mjolnir.drzeus.cx>
In-Reply-To: <20081123213921.667ecb93@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 14 Oct 2008 23:27:59 +0200
> "J.A. Magallón" <jamagallon@ono.com> wrote:
>
>
>   
>>> Have you tested more than one card?
>>>       
>> I have two (both unknown brands for me, but I write full names fwiw):
>> - One "MBA Executive HiSpeed SD", 2Gb
>> - One "takeMS SDHC card Class6",  8Gb
>>
>> Both give about 10Mb/s on read with hdparm under 2.6.27.
>>     
>
> And both work fine in one of the slots, but not the other?
>
>   
>>> What machine is this? 
>>>       
>> It's an Acer Aspire One. From what I have seen, there are two SD devices.
>> Both are capable to read SDHC cards, I have switched cards and they work
>> (or at the moment both are working as backwards-compatible in plain SD
>> mode, if that even exists...).
>>     
>
> The SD/SDHC distinction is all software, so the hardware doesn't really
> care.
>
>   
>> I call this half-working because I have to boot with a card inside a slot
>> to have it detected. If i boot without the card-in, it even dissapears from
>> lspci. This is just with the left SD inserted:
>>
>>     
>
> No idea why this occurs. I'd guess some ACPI voodoo. You're going to
> have to check with the PCI and/or ACPI guys to figure that part of the
> mystery out.
>   

This specific problem is what I thought Matthew's acpiphp patch would 
solve - see my comment 
<http://bugzilla.kernel.org/show_bug.cgi?id=11828#c1>.

If I've got this right, then this *specific* issue isnot a regression.

Matthew, if I have confused two similar issues, could you please help by 
explaining the differences?

Thanks
Alan
