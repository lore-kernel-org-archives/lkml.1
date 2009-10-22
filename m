Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZJVRsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZJVRsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 13:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbZJVRsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 13:48:36 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:3342 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbZJVRsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 13:48:35 -0400
X-Spam-Flag: NO
X-Spam-Score: -11.374
Message-ID: <4AE09AFF.805@tremplin-utc.net>
Date: Thu, 22 Oct 2009 19:48:47 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not  work	anymore
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <20091015215944.GA9845@core.coreip.homeip.net> <4ADF6237.9070004@tremplin-utc.net> <200910211320.16339.dmitry.torokhov@gmail.com> <4AE0840C.8070801@tremplin-utc.net> <20091022162202.GA18031@core.coreip.homeip.net>
In-Reply-To: <20091022162202.GA18031@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-10-09 18:22, Dmitry Torokhov schreef:
> On Thu, Oct 22, 2009 at 06:10:52PM +0200, Éric Piel wrote:
>> Op 21-10-09 22:20, Dmitry Torokhov schreef:
>>>
>>> Nothing, as far as I can tell... I see you typing "qwerty"... Does the
>>> keyboard work in console (let's say if you boot in run level 3 to take X out
>>> of the picture)? Could you please try compiling evbug module - it will show if
>>> keyboard events are propagated through input core. Also, whta driver are you
>>> using in X? Legacy keyboard or evdev?
>> In the console (in init 3), I haven't managed to reproduce it. In xorg,
>> the keyboard input uses evdev. Now I've just tried "evtest
>> /dev/input/event4", when the keyboard doesn't work... and I see the key
>> presses!
>>
>> So I guess it rules out a bug in the kernel, and I have to talk with the
>> people from Xorg, right?
>>
>
> Yep... but it is still wierd since evdev driver works fine for me...
> Could it be you are using either too old or too new version of X?
>
I don't think so: xorg 1.6.5, with xinput-evdev 2.2.5. They are both 
latest or second latest stable versions.

In the log I see this:
(--) SynPS/2 Synaptics TouchPad: touchpad found
(II) PS/2 Generic Mouse: Device reopened after 1 attempts.
(EE) AT Translated Set 2 keyboard: device key_bitmask has changed
(EE) AT Translated Set 2 keyboard: Device has changed - disabling.

Quite a few people seem to have the same problem.

Eric
