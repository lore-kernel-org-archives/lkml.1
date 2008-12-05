Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbYLEFZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbYLEFZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 00:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYLEFZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 00:25:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:41136 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYLEFZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 00:25:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=n6A4AWMCwwH0rni46EwuF33xaWzVLMD75C82XO0QiXcf61lop2Hd7IpPT9U0sGw7EO
         oPA/whdK2+0/EMccw4JA/dZufzaMwv5BajwBlrJ9DVhk6TruGQ42wgWa6YryfqaR2efp
         rpyS/Yf9taB1D/GHbJOC84iPCK6QsIYTfoLXY=
Message-ID: <4938BB26.2030300@gmail.com>
Date: Fri, 05 Dec 2008 06:24:54 +0100
From: =?ISO-8859-1?Q?=22Niklas_=5C=22Nille=5C=22_=C5kerstr=F6m=22?= 
	<nille.kungen@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Robby Workman <rw@rlworkman.net>, hancockr@shaw.ca
Subject: Re: sony-ericsson W800 cellular doesn't work as an usb mass storage
 device
References: <4937447F.6070805@gmail.com>	<4938A9CA.5000903@shaw.ca> <20081204223244.36289afe@liberty.rlwhome.lan>
In-Reply-To: <20081204223244.36289afe@liberty.rlwhome.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robby Workman wrote:
> On Thu, 04 Dec 2008 22:10:50 -0600
> Robert Hancock <hancockr@shaw.ca> wrote:
>
>   
>> Niklas "Nille" Åkerström wrote:
>>     
>>> Please CC any replies; not subscribed to list
>>>
>>> I can't mount my sony-ericsson W800 cellular as an usb mass storage 
>>> device (it doesn't show up as an device).
>>> I run slackware-current (slackware 12.2 rc1)
>>> Using kernel 2.6.27.7
>>> It doesn't even show up when i run 'fdisk -l'
>>>
>>> How ever running slackware 12.1 using kernel 2.6.24.5 works (used
>>> my other box for 12.1 testing)
>>> I also tried the 12.1 kernel 2.6.24.5 in slackware 12.2 rc1 and
>>> then it works.
>>> So it's seems kernel related. (but i'm not experienced enuff to
>>> know)
>>>
>>> Kernel config 2.6.27.7 http://pastebin.com/m4ba5debe
>>> Kernel config 2.6.24.5 http://pastebin.com/m20a78c4f
>>> dmesg when pluging in the device on 2.6.27.7
>>> http://pastebin.com/m56d5e2e8 dmesg when pluging in the device on
>>> 2.6.24.5 running 12.1 http://pastebin.com/m65e4fd04
>>> dmesg when pluging in the device on 2.6.24.5 running current 
>>> http://pastebin.com/m2ac79d09
>>>
>>> My computer is an Compaq Presario 2800
>>> Phone Sony Ericsson W800i 0fce:d028
>>> What other information would be useful?
>>>
>>> I searched the mailing list and found
>>> http://lkml.org/lkml/2008/9/11/276 which seems releated but there
>>> was no answer.
>>>       
>> What do you mean doesn't show up as a device? There doesn't seem to
>> be anything unusual in the kernel log, you should have a /dev/sda1
>> device available (at least if udev, etc. are doing their job)..
>>
>>     
>
> Hrm...
>
> Kay, is this perhaps related to any of the recent serial devices
> discussion on udev list?  We've got udev-135 in 12.2rc1, but 12.1
> shipped udev-118.  Even so, report advises that this still works
> properly on the 12.1 kernel (2.6.24.5) even with udev-135.
>
> -RW
>   
I also think it should show up as /dev/sda1 but it doesn't. (there is no /dev/sda1 device)
When i use the same setup (udev-135 etc.) and only downgrades the kernel to 2.6.24.5
 then it shows up as an mountable device and works as it should.
This made me guess that it has something to do with the 2.6.27.7 kernel.
But i'm only guessing.

-Nille


