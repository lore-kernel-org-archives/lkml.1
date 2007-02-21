Return-Path: <linux-kernel-owner+w=401wt.eu-S1161181AbXBULmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161181AbXBULmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbXBULmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:42:21 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:42595 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbXBULmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:42:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XWsyBncAhK/fu90YGoAP6ffIblv2G8sV5iUJpPXuqjJ2ssKp2I05dr6kufnvHoJ6T7HM45xQNdJg+pNr5Dx6lzvDjj/+NHv9/fLDzw9iXXOE4h0Duc0Ot237wNa/bl/bVi76geWweSF+F33ronDbx5hjQ7YDqf2Dd5Xivzd87KA=
Message-ID: <45DC3018.7010704@gmail.com>
Date: Wed, 21 Feb 2007 20:42:16 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Leopold Palomo-Avellaneda <lepalom@wol.es>
CC: Jean Delvare <jdelvare@suse.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Sata_via problems in a Vintage2-AE1: Resume
References: <200702090010.06897.lepalom@wol.es> <200702131711.11781.lepalom@wol.es> <200702131719.47507.jdelvare@suse.de> <200702151223.19333.lepalom@wol.es>
In-Reply-To: <200702151223.19333.lepalom@wol.es>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Leopold Palomo-Avellaneda wrote:
> A Dimarts 13 Febrer 2007 17:19, Jean Delvare va escriure:
>> Le Mardi 13 Février 2007 17:11, Leopold Palomo-Avellaneda a écrit :
>>> A Dimarts 13 Febrer 2007 12:20, Jean Delvare va escriure:
>>> (...)
>>>
>>>>>> *If* the VT8251 needs the VIA IRQ quirk, then the attached patch
>>>>>> may help. Leopold, can you give it a try?
>>>>> Well, making your patch to the vanilla 2.6.20 the result is the same.
>>>>> The box doesn't boot. Always the same problem ....
>>>> If it's not a VIA IRQ problem, then there's nothing more I can do,
>>>> sorry. Someone else will have to look into the problem.
>>>>
>>>> Out of curiosity, with my patch applied, did you see any "VIA VLink IRQ
>>>> fixup" messages on the console?
>>> No :-(
>> OK, so maybe the VT8251 actually no longer needs the quirk. Thanks for
>> testing and reporting.
> 
> 
> Hi people,
>  
> arriving to this state. What do you recommend?
> 
> I have the box more or less working with irqpoll but with a lot of messages:
> APIC error on CPU0: 08(08)
> 
> and the box doesn't boot without the irqpoll option. Do you think that the 
> 2.6.21 have some kind of changes in this area?
> 
> Thank's for all for you patience and your messages.

I'm sorry but I'm clueless other than that it seems to be an irq routing
problem.

Any ideas, people?

-- 
tejun
