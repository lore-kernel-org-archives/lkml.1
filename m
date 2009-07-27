Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZG0Tx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZG0Tx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZG0Txz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:53:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:42770 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZG0Txy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vT+Vt2RcPmXguDCeBhesX+RxAekzoJdQxNKdKL7xDb7ctxmTZHM5Bfnj5nmEdMamIm
         pZcCf3Z63HF/CK0JvujQZR8YBDVsRwbpIafauYIGgjOupxC8q7tsdUcOj1aYUevvlI8G
         USKH9/q4wrL9+MgkK2q64XpEtkGZ0q4jjzZh0=
Message-ID: <4A6E05D4.5060308@gmail.com>
Date: Mon, 27 Jul 2009 12:53:56 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm:i915_driver_irq_handler] *ERROR* EIR stuck: 0x00000010,
 masking
References: <dd18b0c30907261812p673a3ab3p8dd7ca41465c7f05@mail.gmail.com>	<20090727101524.778c83ab@jbarnes-g45>	<4A6DE5C0.4000607@gmail.com> <20090727104335.0a9a1556@jbarnes-g45>
In-Reply-To: <20090727104335.0a9a1556@jbarnes-g45>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Mon, 27 Jul 2009 10:37:04 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>    
>> Jesse Barnes wrote:
>>      
>>> On Sun, 26 Jul 2009 21:12:49 -0400
>>> Justin Mattock<justinmattock@gmail.com>   wrote:
>>>
>>>
>>>        
>>>> to my surprise this machine still works...
>>>> (dell inspiron 1200)
>>>> Anyways in dmesg I see:
>>>>
>>>> [   10.188083] b43-pci-bridge 0000:03:00.0: setting latency timer
>>>> to 64 [   10.191947] ssb: Sonics Silicon Backplane found on PCI
>>>> device 0000:03:00.0 [   10.220248] fb: conflicting fb hw usage
>>>> inteldrmfb vs VESA VGA - removing generic driver
>>>> [   10.222343] Console: switching to colour dummy device 80x25
>>>> [   10.225625] Console: switching to colour frame buffer device
>>>> 128x48 [   10.278714] render error detected, EIR: 0x00000010
>>>> [   10.278717] page table error
>>>> [   10.278720]   PGTBL_ER: 0x00000100
>>>> [   10.278725] [drm:i915_driver_irq_handler] *ERROR* EIR stuck:
>>>> 0x00000010, masking
>>>> [   10.278742] render error detected, EIR: 0x00000010
>>>> [   10.278745] page table error
>>>> [   10.278747]   PGTBL_ER: 0x00000100
>>>> [   10.290087] [drm] LVDS-8: set mode 1024x768 c
>>>> [   10.640403] [drm] fb0: inteldrmfb frame buffer device
>>>> [   10.640597] [drm] Initialized i915 1.6.0 20080730 for
>>>> 0000:00:02.0 on minor 0 [   10.679818] b43-phy0: Broadcom 4306
>>>> WLAN found (core revision 5)
>>>>
>>>> direct rendering still seems to be intact,
>>>> suspend not sure(test in a moment).
>>>>
>>>>          
>>> Sounds like a dupe of the issue Frans reported.  We report errors
>>> like this now rather than silently ignoring them.  This one must be
>>> harmless or your machine wouldn't ever have worked. :)
>>>
>>>
>>>        
>> Seems harmless to me, one thing I see is
>> during the boot process Ill see the boot messages, then once
>> init/udev starts up, and loads i915 the screen will go black
>> for a tenth or so of a second, then goes back to normal. Now keep in
>> mind this might be something suse does during the boot process.
>> (I can try loading ubuntu/debian to see if the affects are the same
>> once I get a chance).
>>      
>
> Yeah that's probably just the i915 driver probing the outputs.  It
> shuts everything off to avoid showing any ugly load detect patterns or
> flicker.
>
>    
Alright,
Then that's pretty much everything, other than
a message that's been there, but now finally is showing itself.

Justin P. Mattock
