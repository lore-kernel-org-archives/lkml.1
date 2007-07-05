Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbXGEXsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbXGEXsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759102AbXGEXs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:48:29 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:32832 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005AbXGEXs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:48:28 -0400
Message-ID: <468D832C.5090805@blueyonder.co.uk>
Date: Fri, 06 Jul 2007 00:47:56 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: ov511 module does not build
References: <468ADA8D.10108@blueyonder.co.uk> <20070705025417.GO3492@stusta.de>
In-Reply-To: <20070705025417.GO3492@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Jul 04, 2007 at 12:23:57AM +0100, Sid Boyce wrote:
>   
>> With the same setup in .config for linux-2.6.22-rc2-git7, it builds, after 
>> that and right up to linux-2.6.22-rc7-git1 it doesn't.
>> /usr/src/linux-2.6.22-rc2-git7/drivers/media/video/ov511.ko
>> # CONFIG_VIDEO_V4L1 is not set
>>     
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> That's the problem.
>
>   
>> CONFIG_VIDEO_V4L1_COMPAT=y
>> In any of the 2.6.22-rc kernels, there is no option to select OV511.
>> tindog:/usr/src/linux-2.6.22-rc2-git7 # grep -i ov511 .config
>> tindog:/usr/src/linux-2.6.22-rc2-git7 #
>>
>> tindog:/usr/src/linux-2.6.22-rc7-git1 # diff 
>> ../linux-2.6.22-rc2-git7/drivers/media/video/Kconfig 
>> drivers/media/video/Kconfig
>> 14c14
>> < if VIDEO_CAPTURE_DRIVERS
>> ---
>>     
>>> if VIDEO_CAPTURE_DRIVERS && VIDEO_DEV
>>>       
>> 694c694
>> < if V4L_USB_DRIVERS
>> ---
>>     
>>> if V4L_USB_DRIVERS && USB
>>>       
>> tindog:/usr/src/linux-2.6.22-rc7-git1 # grep V4L .config
>> # CONFIG_VIDEO_V4L1 is not set
>> CONFIG_VIDEO_V4L1_COMPAT=y
>> CONFIG_VIDEO_V4L2=y
>> CONFIG_V4L_USB_DRIVERS=y
>>
>> tindog:/usr/src/linux-2.6.22-rc2-git7 # grep V4L .config
>> # CONFIG_VIDEO_V4L1 is not set
>>     
>
> If it built with this version and this .config, something went wrong.
>
> Are you sure this is the correct .config that built the ov511 module?
>
>   
>> CONFIG_VIDEO_V4L1_COMPAT=y
>> CONFIG_VIDEO_V4L2=y
>> # CONFIG_V4L_USB_DRIVERS is not set
>>
>> Still does not build for 2.6.22-rc7-git2 with .config set with
>>
>> # CONFIG_V4L_USB_DRIVERS is not set
>>
>> Regards
>> Sid.
>> -- 
>> Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
>> Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
>> Specialist, Cricket Coach
>> Microsoft Windows Free Zone - Linux used for all Computing Tasks
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>     
>
> cu
> Adrian
>
>   
Thanks, I see, I didn't select that as it said it was DEPRECATED, now 
I've selected OV511.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


