Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYKELjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYKELjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 06:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYKELjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 06:39:40 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:45375 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbYKELjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 06:39:39 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <49118600.3010409@gmail.com>
Date: Wed, 05 Nov 2008 11:39:44 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Albert Comerma <albert@ecm.ub.es>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SISUSB2VGA driver add 0x0711, 0x0903
References: <49106D7F.8080902@ecm.ub.es> <20081104104332.eb9f36ca.akpm@linux-foundation.org> <4910BA46.5090700@ecm.ub.es>
In-Reply-To: <4910BA46.5090700@ecm.ub.es>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this has come up.  Has anyone had any luck with the version with vid
and pid
0x0711, 0x0914?

The good old add the id and cross your fingers fails with a Failed to
early initialize device
message.

--
Jonathan


> Sorry, but since it was so an "easy" patch I thought it was not needed :P
> I add some more information;
> This adds a new device I bought some time ago from www.compatible.eu,
> but Its produced by Startech (www.startech.com).
> Looking the device VID and PID it seems the normal evolution of the
> previous products supported by the linux driver sisusb2vga.
> It permits to add an external display using a normal usb2 port to your
> computer. Up to 16 displays connected to the usb (in theory) with a
> maximum resolution of 1280x1024 and 32bits. The only problem is the
> lack of acceleration and the poor refresh rate, but it works quite
> well for mostly static display (for example your mail software).
> I've been using it for nearly a year without any problem using
> xinerama configuration on xorg.
> I've had had also reports from some people using it without problems
> (see http://www.sidux.com/index.php?module=pnWikka&tag=usb2vga ).
> For more information and pictures just have a look at;
> http://www.comerma.net/usb2vga_en.html
>
> Albert
>
> En/na Andrew Morton ha escrit:
>> On Tue, 04 Nov 2008 16:42:55 +0100
>> Albert Comerma <albert@ecm.ub.es> wrote:
>>
>>  
>>> After some comments (thanks a lot) I resend the patch, hoping now it
>>> reaches the adequate person.
>>>
>>> Signed-off-by:  Albert Comerma <albert.comerma@gmail.com>
>>>
>>>
>>> [sisusb.patch  text/x-diff (565B)]
>>> diff -r -u linux-2.6.27.4/drivers/usb/misc/sisusbvga/sisusb.c
>>> linux-2.6.27.4-new/drivers/usb/misc/sisusbvga/sisusb.c
>>> --- linux-2.6.27.4/drivers/usb/misc/sisusbvga/sisusb.c    2008-10-26
>>> 00:05:07.000000000 +0200
>>> +++ linux-2.6.27.4-new/drivers/usb/misc/sisusbvga/sisusb.c   
>>> 2008-11-03 15:21:03.000000000 +0100
>>> @@ -3270,6 +3270,7 @@
>>>      { USB_DEVICE(0x0711, 0x0900) },
>>>      { USB_DEVICE(0x0711, 0x0901) },
>>>      { USB_DEVICE(0x0711, 0x0902) },
>>> +    { USB_DEVICE(0x0711, 0x0903) },
>>>      { USB_DEVICE(0x0711, 0x0918) },
>>>      { USB_DEVICE(0x182d, 0x021c) },
>>>      { USB_DEVICE(0x182d, 0x0269) },
>>>     
>>
>> Could we please have some description of this patch?  What device are
>> we supporting here?  Manufacturer/model/etc?  Something.  Anything!
>>   
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

