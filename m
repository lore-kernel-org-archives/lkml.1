Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYKDVKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYKDVKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYKDVKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:10:41 -0500
Received: from tombstone.ecm.ub.es ([161.116.81.124]:2594 "EHLO
	tombstone.ecm.ub.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbYKDVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:10:40 -0500
Message-ID: <4910BA46.5090700@ecm.ub.es>
Date: Tue, 04 Nov 2008 22:10:30 +0100
From: Albert Comerma <albert@ecm.ub.es>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SISUSB2VGA driver add 0x0711, 0x0903
References: <49106D7F.8080902@ecm.ub.es> <20081104104332.eb9f36ca.akpm@linux-foundation.org>
In-Reply-To: <20081104104332.eb9f36ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, but since it was so an "easy" patch I thought it was not needed :P
I add some more information;
This adds a new device I bought some time ago from www.compatible.eu, 
but Its produced by Startech (www.startech.com).
Looking the device VID and PID it seems the normal evolution of the 
previous products supported by the linux driver sisusb2vga.
It permits to add an external display using a normal usb2 port to your 
computer. Up to 16 displays connected to the usb (in theory) with a 
maximum resolution of 1280x1024 and 32bits. The only problem is the lack 
of acceleration and the poor refresh rate, but it works quite well for 
mostly static display (for example your mail software).
I've been using it for nearly a year without any problem using xinerama 
configuration on xorg.
I've had had also reports from some people using it without problems 
(see http://www.sidux.com/index.php?module=pnWikka&tag=usb2vga ).
For more information and pictures just have a look at; 
http://www.comerma.net/usb2vga_en.html

Albert

En/na Andrew Morton ha escrit:
> On Tue, 04 Nov 2008 16:42:55 +0100
> Albert Comerma <albert@ecm.ub.es> wrote:
>
>   
>> After some comments (thanks a lot) I resend the patch, hoping now it 
>> reaches the adequate person.
>>
>> Signed-off-by:  Albert Comerma <albert.comerma@gmail.com>
>>
>>
>> [sisusb.patch  text/x-diff (565B)]
>> diff -r -u linux-2.6.27.4/drivers/usb/misc/sisusbvga/sisusb.c linux-2.6.27.4-new/drivers/usb/misc/sisusbvga/sisusb.c
>> --- linux-2.6.27.4/drivers/usb/misc/sisusbvga/sisusb.c	2008-10-26 00:05:07.000000000 +0200
>> +++ linux-2.6.27.4-new/drivers/usb/misc/sisusbvga/sisusb.c	2008-11-03 15:21:03.000000000 +0100
>> @@ -3270,6 +3270,7 @@
>>  	{ USB_DEVICE(0x0711, 0x0900) },
>>  	{ USB_DEVICE(0x0711, 0x0901) },
>>  	{ USB_DEVICE(0x0711, 0x0902) },
>> +	{ USB_DEVICE(0x0711, 0x0903) },
>>  	{ USB_DEVICE(0x0711, 0x0918) },
>>  	{ USB_DEVICE(0x182d, 0x021c) },
>>  	{ USB_DEVICE(0x182d, 0x0269) },
>>     
>
> Could we please have some description of this patch?  What device are
> we supporting here?  Manufacturer/model/etc?  Something.  Anything!
>   

