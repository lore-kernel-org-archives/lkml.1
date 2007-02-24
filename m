Return-Path: <linux-kernel-owner+w=401wt.eu-S1750729AbXBXRME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750729AbXBXRME (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 12:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXBXRMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 12:12:03 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47381 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbXBXRMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 12:12:01 -0500
X-Sasl-enc: RCjr3SW4cFyQ92OxIO/OQnbTw7OOkD6+Wd8MvPCspnQ6 1172337119
In-Reply-To: <200702241624.17024.bzolnier@gmail.com>
References: <8d158e1f0702240210x71f981a6xf2fe8917dac5e91a@mail.gmail.com> <200702241624.17024.bzolnier@gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6C96CE3D-85F5-479D-BD44-F5DA0AE744FF@fastmail.to>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <jonesml@fastmail.to>
Subject: Re: [QUESTION] Sata RAID
Date: Sat, 24 Feb 2007 17:11:56 +0000
To: Patrick Ale <patrick.ale@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

But using 'fakeraid' (i.e. BIOS RAID) together with dmraid is  
generally discouraged in favour of using the more stable and well  
supported Linux Software RAID functionality.

Michael-Luke

On 24 Feb 2007, at 15:24, Bartlomiej Zolnierkiewicz wrote:

>
> use device mapper and dmraid
>
> 	http://people.redhat.com/~heinzm/sw/dmraid/
>
> and please read
>
> 	http://linux-ata.org/faq-sata-raid.html
>
> On Saturday 24 February 2007, Patrick Ale wrote:
>> Hi,
>>
>> Quick question,
>>
>> Since I am going to open my server today to do some pata tests (for
>> the weird detection problems people are giving me fantastic help  
>> with,
>> no sarcasm, I really mean it) I thought: why not add two 320GB SATA
>> disks on the SATA controller that the mainboard has.
>>
>> I am wondering: should I use the onboard RAID function? Is this
>> supported by Linux? I remember back in "the old days (TM)" there were
>> seperate (spelling) drivers for ataraid, how does the current 2.6
>> branch cope with the RAID functions of modern motherboards?
>>
>> I am aware that it is NOT hardware raid, the raid is done in the
>> driver, which is why you need this fancy boot disk before installing
>> Windows on your RAID set.
>>
>> Or would you suggest me to stick with MD devices?
>>
>>
>> Cheers,
>>
>> Patrick Ale
>> patrick.ale@gmail.com
>>
>> "kun kasvan isoksi, halun olla poro"
> -
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

