Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616Ab0AJQ2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0AJQ2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513Ab0AJQ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:28:42 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:51697 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0AJQ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:28:41 -0500
Date: Sun, 10 Jan 2010 11:27:58 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: System stop with kernel 2.6.32.2 and kernel-linus 2.6.33.0-rc2//rc3
In-reply-to: <BLU0-SMTP71AE1AC6DF8DA389599B0DCD6E0@phx.gbl>
To: Megastorage <megastorage@hotmail.fr>
Cc: linux-kernel@vger.kernel.org
Message-id: <4B4A000E.4060103@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <4B3E1BF4.2090005@hotmail.fr>
 <BLU0-SMTP71AE1AC6DF8DA389599B0DCD6E0@phx.gbl>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silly question, do you have the raid module loaded? I hit the same thing 
a while back as mkinitrd didn't properly include the raid456 driver into 
initrd. I'd go back to the working system, do an lsmod see what's 
running, then check the initrd for the failed system and make sure 
you've got all the pieces.
On 1/10/2010 10:57 AM, Megastorage wrote:
> I'm testing with the kernel 2.6.33 RC3, same problem.
>
> Stef.
>
> Megastorage a écrit :
>> Dear all,
>>
>> Sorry for my english, I'm french and I'm not an expert to report a bug.
>>
>> I working with Mandriva cooker.
>>
>> My system can start on kernel 2.6.31.6 whitout problem.
>>
>> If  I start on  the kernel  2.6.32.2, my system stop on this screen:
>> http://img198.imageshack.us/img198/416/dscf2869k.jpg
>> http://img24.imageshack.us/img24/9079/dscf2870.jpg
>>
>> I'm testing with the kernel-linus 2.6.33.0-RC2 faults to:
>> http://img515.imageshack.us/i/dscf2871.jpg/
>>
>>
>> My fstab:
>> http://en.pastebin.ca/1734080
>>
>> My hardware configuration:
>> Asus A8N-sli deluxe
>> Raid system on the chipset nvidia and Silicon image.
>>
>>
>> If you need more information. You can ask me.
>>
>> Thanks for your help.
>> Stephane.
>>
>>
>>
>>
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

