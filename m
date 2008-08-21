Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbYHUWre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbYHUWre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 18:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758303AbYHUWrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 18:47:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:28080 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbYHUWrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 18:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fUi0hoSO7ioFI5Df7HKQH/rSupzNzoXqadln8KsZ5gZVtkdaZ3us9pGdZDXHxXVcwM
         BbgYD50+fmus3L93PNus6zk0HQ7GdL+wMCxCHooCNcbomloEHkEWOCtzrCJ6YF+cDPMM
         voNcvSkdGFesWnWTW05tJ8IO5ZUyref8xYovA=
Message-ID: <dd18b0c30808211547l27591f0aia498e08997f64b2@mail.gmail.com>
Date: Thu, 21 Aug 2008 15:47:22 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: evdev.c(EVIOCGBIT): Suspicious buffer size 511,
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
In-Reply-To: <dd18b0c30808200931x2aea0dc6t2986b7a4c3daeff9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30808172310u7cf7836ai15e19485908ae0ce@mail.gmail.com>
	 <20080820000040.55015b48.akpm@linux-foundation.org>
	 <20080820092806.ZZRA012@mailhub.coreip.homeip.net>
	 <dd18b0c30808200931x2aea0dc6t2986b7a4c3daeff9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 9:31 AM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Wed, Aug 20, 2008 at 6:31 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> On Wed, Aug 20, 2008 at 12:00:40AM -0700, Andrew Morton wrote:
>>> On Sun, 17 Aug 2008 23:10:54 -0700 "Justin Mattock" <justinmattock@gmail.com> wrote:
>>>
>>> > I'm noticing:
>>> > evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64
>>> > bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
>>> > with rc-3 not with rc2.
>>> > Did the patch to synaptics, seems
>>> > my xorg is not reading /usr/X11R6/lib/modules/input/synaptics_drv.o
>>> > only /usr/lib/xorg/modules/input/synaptics_drv.so
>>> > is there any easy fix, or do I have to recompile xorg?
>>> > regards;
>>> >
>>>
>>> (cc's added)
>>>
>>
>> You can just copy the updated file manually into
>> /usr/lib/xorg/modules/input/.
>>
>> I tried rebuilding synaptics from here:
>>
>> git://anongit.freedesktop.org/git/xorg/driver/xf86-input-synaptics
>>
>> but unfortunately it fails with some automake crap that I don't have
>> time to trace through at the moment.
>>
>> --
>> Dmitry
>>
>
> Cool, I'll have a try at it again.
> What I did was copy /usr/lib/X11R6/lib/modules/input/synaptics_drv.o
> to /usr/lib/xorg/modules/input/   then renamed it to synaptics_drv.so
> the module loads but is broken.  When given time today I'll try and
> reinstall, and see if I can get it working.
>
>
> --
> Justin P. Mattock
>


debian SID  upgraded there package
for synaptic message
is fixed.

-- 
Justin P. Mattock
