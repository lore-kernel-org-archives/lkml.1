Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881Ab0AVCat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab0AVCat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867Ab0AVCar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:30:47 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:33781 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab0AVCao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:30:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mLI+bTkts6kpyZaxfghID4aqpbgR1N3NfKjY8SwZwe+EvYgaJ2wcBj8EC9ChG6rc3+
         VDeWe+hiFb07/PjvaP6E3PvUAAmaygEuOxsXrzBHKpzopbFndQ/39iReU7oEw/fAa4FG
         ENnf3OrCaZhC3gtO4hWFY2Zpi7m2GveU93FXo=
Message-ID: <4B590E19.5080903@gmail.com>
Date: Thu, 21 Jan 2010 18:31:53 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>
CC: Robert Hancock <hancockrwd@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <1264011793.1735.3683.camel@localhost.localdomain>	 <4B57A2D4.9030204@gmail.com>	 <20100121185544.GB11996@core.coreip.homeip.net>	 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>	 <4B58CBEE.5020301@gmail.com>	 <51f3faa71001211629n1b556649t32c184e49dc32dfb@mail.gmail.com>	 <4B58FD48.9020209@gmail.com> <1264126146.28766.0.camel@localhost.localdomain>
In-Reply-To: <1264126146.28766.0.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/10 18:09, Bastien Nocera wrote:
> On Thu, 2010-01-21 at 17:20 -0800, Justin P. Mattock wrote:
>> On 01/21/10 16:29, Robert Hancock wrote:
> <snip>
>>> cat /sys/bus/pnp/devices/*/id
>>>
>>> and see if any of these are present?
>>>
>>> PNP0303
>>> PNP030b
>>> FJC6000
>>> FJC6001
>>> PNP0f03
>>> PNP0f0b
>>> PNP0f0e
>>> PNP0f12
>>> PNP0f13
>>> PNP0f19
>>> PNP0f1c
>>> SYN0801
>>>
>>
>>
>> both macbook pro, and iMac9,1
>> have:
>> PNP0a08
>> PNP0a03
>
> # cat /sys/bus/pnp/devices/*/id
> PNP0a08
> PNP0a03
> PNP0c02
> APP0001
> PNP0200
> INT0800
> PNP0103
> PNP0c01
> PNP0c04
> PNP0c02
> PNP0b00
>
> On a MacbookAir1,1
>
>

duh!! I only did one device
here's the two machines I have:

iMac9,1

PNP0a08
PNP0a03
PNP0c02
APP0001
PNP0200
PNP0103
PNP0c01
PNP0c04
PNP0c02
PNP0b00


MacBookPro2,2

PNP0a08
PNP0a03
PNP0c02
APP0001
PNP0200
INT0800
PNP0103
PNP0c01
PNP0c04
PNP0c02
PNP0b00

Justin P. Mattock

