Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZIRIOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZIRIOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 04:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZIRIOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 04:14:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12405 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZIRIOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 04:14:36 -0400
Date: Fri, 18 Sep 2009 17:14:39 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
In-reply-to: <20090916085749.GL2756@core.coreip.homeip.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
       "'Trilok Soni'" <soni.trilok@gmail.com>,
       "'Kim Kyuwon'" <q1.kim@samsung.com>,
       "'Kim Kyuwon'" <chammoru@gmail.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       "'Kyungmin Park'" <kyungmin.park@samsung.com>
Message-id: <4AB3416F.6010004@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <5d5443650907130152t420e9426q762c24bdb1b29aae@mail.gmail.com>
 <20090713093147.GJ10819@dtor-d630.eng.vmware.com>
 <4A5BF6F0.6020403@samsung.com>
 <001801ca044c$428839d0$c798ad70$%szyprowski@samsung.com>
 <20090714082452.GH2822@dtor-d630.eng.vmware.com>
 <002a01ca0462$8b750a90$a25f1fb0$%szyprowski@samsung.com>
 <5d5443650907140211i4c6e4a49q9c055dc1e91071da@mail.gmail.com>
 <002b01ca046c$7f9fd240$7edf76c0$%szyprowski@samsung.com>
 <5d5443650907140323l6cc06151nbec94d5d8646c60a@mail.gmail.com>
 <003f01ca051c$0e8d12b0$2ba73810$%szyprowski@samsung.com>
 <20090916085749.GL2756@core.coreip.homeip.net>
X-OriginalArrivalTime: 18 Sep 2009 08:14:38.0598 (UTC)
 FILETIME=[10E0EA60:01CA3838]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/2009 5:57 PM, Dmitry Torokhov wrote:
> On Wed, Jul 15, 2009 at 09:15:34AM +0200, Marek Szyprowski wrote:
>> Hello,
>>
>> On Tuesday, July 14, 2009 12:23 PM Trilok Soni wrote:
>>
>>> On Tue, Jul 14, 2009 at 3:48 PM, Marek
>>> Szyprowski<m.szyprowski@samsung.com> wrote:
>>>> Hello,
>>>>
>>>> On Tuesday, July 14, 2009 11:12 AM, Trilok Soni wrote:
>>>>
>>>>> On Tue, Jul 14, 2009 at 2:37 PM, Marek
>>>>> Szyprowski<m.szyprowski@samsung.com> wrote:
>>>>>> Hello,
>>>>>>
>>>>>> On Tuesday, July 14, 2009 10:25 AM, Dmitry Torokhov wrote:
>>>>>>
>>>>>>> On Tue, Jul 14, 2009 at 08:28:05AM +0200, Marek Szyprowski wrote:
>>>>>>>> Hello,
>>>>>>>> On Tuesday, July 14, 2009 5:10 AM, Kim Kyuwon wrote:
>>>>>>>>> Dmitry Torokhov wrote:
>>>>>>>>>> On Mon, Jul 13, 2009 at 02:22:10PM +0530, Trilok Soni wrote:
>>>>>>>>>>> I don't see this driver picked up yet in your -next branch. We should
>>>>>>>>>>> target this driver to be mainlined in next merge window. This is very
>>>>>>>>>>> important driver for some of the embedded systems, including palm pre
>>>>>>>>>>> :)
>>>>>>>>>> I was wondering if somebody could test the patch below and if it still
>>>>>>>>>> works then I will apply to the next branch. Thanks!
>>>>>>>>>>
>>>>>>>>> Dear Marek,
>>>>>>>>>
>>>>>>>>> Because I don't have the NCP board(which includes the max7359 keypad)
>>>>>>>>> now, I can't test this patch. Marek, could you please test this patch?
>>>>>>>> I would like to, but I could not find the base version to which I can apply
>>>>>>>> that patch. I've tried v2 version posted in '[PATCH] Input: add MAX7359 key
>>>>>>>> switch controller driver, v2' mail from Sat 2009-05-09 04:10 with 2 patches
>>>>>>>> posted in replies to that main, but the latest patch still fails to apply.
>>>>>>>>
>>>>>>>> Could someone send me a complete patch, so I can do a test?
>>>>>>>>
>>>>>>> Sending everything as attachments, maybe that will help...
>>>>>> Ok. I've did the tests.
>>>>>>
>>>>>> MAX7359 keypad driver works after your patch, but reports much more events than
>>>>>> the previous version. In this test I pressed quickly the first button on the
>>>>>> keypad.
>>>>>>
>>>>>> Old version:
>>>>>> NCP:~# hexdump /dev/input/event0
>>>>>> 0000000 0037 0000 e733 000b 0001 00e7 0001 0000
>>>>>> 0000010 0037 0000 e748 000b 0000 0000 0000 0000
>>>>>> 0000020 0037 0000 94e2 000d 0001 00e7 0000 0000
>>>>>> 0000030 0037 0000 94f3 000d 0000 0000 0000 0000
>>>>>>
>>>>> Please use evtest instead. It will give better output atleast.
>>>> Ok.
>>>>
>>>> Old version (clean v2 patch):
>>>>
>>>> NCP:~# evtest /dev/input/event0
>>>> Input driver version is 1.0.0
>>>> Input device ID: bus 0x18 vendor 0x0 product 0x0 version 0x0
>>>> Input device name: "max7359"
>>>> Supported events:
>>>> 잾vent type 0 (Sync)
>>>> 잾vent type 1 (Key)
>>>>   잾vent code 107 (End)
>>>>   잾vent code 139 (Menu)
>>>>   잾vent code 148 (Prog1)
>>>>   잾vent code 149 (Prog2)
>>>>   잾vent code 177 (ScrollUp)
>>>>   잾vent code 178 (ScrollDown)
>>>>   잾vent code 212 (Camera)
>>>>   잾vent code 231 (?)
>>>>   잾vent code 474 (?)
>>>> 잾vent type 20 (Repeat)
>>>> Testing ... (interrupt to exit)
>>>> Event: time 38.740081, type 1 (Key), code 139 (Menu), value 1
>>>> Event: time 38.740101, -------------- Report Sync ------------
>>>> Event: time 38.850061, type 1 (Key), code 139 (Menu), value 0
>>>> Event: time 38.850077, -------------- Report Sync ------------
>>>>
>>>> New version (updated platform definition to use struct matrix_keymap_data instead of
>>> max7359_keypad_platform_data):
>>>> NCP:~# evtest /dev/input/event0
>>>> Input driver version is 1.0.0
>>>> Input device ID: bus 0x18 vendor 0x0 product 0x0 version 0x0
>>>> Input device name: "max7359"
>>>> Supported events:
>>>> 잾vent type 0 (Sync)
>>>> 잾vent type 1 (Key)
>>>>   잾vent code 107 (End)
>>>>   잾vent code 139 (Menu)
>>>>   잾vent code 148 (Prog1)
>>>>   잾vent code 149 (Prog2)
>>>>   잾vent code 177 (ScrollUp)
>>>>   잾vent code 178 (ScrollDown)
>>>>   잾vent code 212 (Camera)
>>>>   잾vent code 231 (?)
>>>>   잾vent code 474 (?)
>>>> 잾vent type 4 (Misc)
>>>>   잾vent code 4 (ScanCode)
>>>> 잾vent type 20 (Repeat)
>>>> Testing ... (interrupt to exit)
>>>> Event: time 75.680066, type 4 (Misc), code 4 (ScanCode), value 01
>>>> Event: time 75.680095, type 1 (Key), code 139 (Menu), value 1
>>>> Event: time 75.680107, -------------- Report Sync ------------
>>>> Event: time 75.700072, type 4 (Misc), code 4 (ScanCode), value 3f
>>>> Event: time 75.700095, -------------- Report Sync ------------
>>>> Event: time 75.830064, type 4 (Misc), code 4 (ScanCode), value 01
>>>> Event: time 75.830093, type 1 (Key), code 139 (Menu), value 0
>>>> Event: time 75.830100, -------------- Report Sync ------------
>>>> Event: time 75.850073, type 4 (Misc), code 4 (ScanCode), value 3f
>>>> Event: time 75.850097, -------------- Report Sync ------------
>>>>
>>>> Something is definitely different. It looks that I missed a patch that added some additional events,
>>> because I don't think that the
>>>> threaded irq patch would cause this.
>>>>
>>> Nope, it is not because of threaded irq patch but MSC_SCAN event
>>> generation. Not to worry.
> 
>> I'm sorry for the commotion, but I did the test in a wrong way. I
>> thought Dmitry has sent me a patch with the threaded irq already
>> integrated. Joonyoung Shim has pointed me that I was wrong. I had to
>> apply the threaded irq patch on top of the patch Dmitry has sent me.
>>
>> To sum up - the threaded irq version does not work here on ARM S3C6410
>> NCP board. In /proc/interrupts I only noticed that only 1 interrupt
>> has been triggered. No events are reported. Same was with Melfas
>> Touchscreen driver (also only 1 interrupt triggered).
>>
> 
> Now that most issues have with threaded IRQs have been fixed in mainline
> would you mind retesting the threaded IRQ patch? Below is the latest
> version of it.
> 
> Thanks!
> 

Hi, Dmitry.

I tested your patch with threaded IRQ. Because the interrupt of the 
MAX7359 device is the low level detecting, i should add the IRQF_ONESHOT 
flag on request_threaded_irq(). If it is added IRQF_ONESHOT flag, the it
operates well.
                                                                                                       
Do you want i send the patch?
