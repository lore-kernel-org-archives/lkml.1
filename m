Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbXE2RGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbXE2RGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbXE2RGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:06:04 -0400
Received: from rtr.ca ([64.26.128.89]:4853 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbXE2RGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:06:02 -0400
Message-ID: <465C5D79.9050701@rtr.ca>
Date: Tue, 29 May 2007 13:06:01 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
References: <465C566E.4030009@rtr.ca> <29495f1d0705291003m1eb54966j82c3878c9a503b84@mail.gmail.com>
In-Reply-To: <29495f1d0705291003m1eb54966j82c3878c9a503b84@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nish Aravamudan wrote:
> On 5/29/07, Mark Lord <lkml@rtr.ca> wrote:
>> I just "upgraded" from 2.6.21.3 to 2.6.22-rc3,
>> but will be rebooting back into 2.6.21.xx shortly.
>>
>> Suspend/Resume (RAM) works perfectly on this Dell i9400 dual-core 
>> notebook.
>> Except with 2.6.22-rc3, all USB devices are non-functional on resume.
>> Most of the time.
>> Once in five reboots, my mouse worked after the first suspend/resume 
>> cycle,
>> but not thereafter.  'lsusb' also hangs after resume.
> 
> Could this be related to: http://lkml.org/lkml/2007/5/27/56/?

No, the .config here has CONFIG_USB_DEVICE_CLASS=y

Thanks.
