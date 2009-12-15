Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZLOGav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZLOGav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZLOGau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:30:50 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:55417 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZLOGau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:30:50 -0500
MIME-Version: 1.0
In-Reply-To: <d6200be20912121441w7086f09fv47e8119e55345be2@mail.gmail.com>
References: <20091205221100.GA32522@elf.ucw.cz>
	 <1260054737.23633.35.camel@desktop>
	 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
	 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
	 <20091212112536.GA2302@elf.ucw.cz> <20091212175327.GA5819@elf.ucw.cz>
	 <d6200be20912121441w7086f09fv47e8119e55345be2@mail.gmail.com>
Date: Mon, 14 Dec 2009 22:30:49 -0800
Message-ID: <d6200be20912142230p70bffde9m9ae440f446b87854@mail.gmail.com>
Subject: Re: tree with htc dream support
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/12 Arve Hjønnevåg <arve@android.com>:
> On Sat, Dec 12, 2009 at 9:53 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> On Sat 2009-12-12 12:25:36, Pavel Machek wrote:
>>> On Fri 2009-12-11 21:42:07, Arve Hj?nnev?g wrote:
>>> > On Sat, Dec 5, 2009 at 4:38 PM, Brian Swetland <swetland@google.com> wrote:
>>> > > Arve's about to take our common and msm trees and rebase them over the .32,
>>> > > which may be useful for reference -- at least as a snapshot of a fully
>>> > > functional set of patches that android donut and eclair run on, on
>>> > > production hardware.  We'll make that available as soon as we have something
>>> > > that's bootable.
>>> > >
>>> > > Brian
>>> > >
>>> > >
>>> >
>>> > A first pass of this is available in the android-msm-2.6.32-test1
>>> > branch at git://android.git.kernel.org/kernel/experimental.git.
>>>
>>> According to some docs, i2c_detach can be just removed, so...?
>>>
>>> Then I got this:
>>
>> And then I got it to boot. Good! (And a bit after that, probably
>> watchdog kicked and phone rebooted back into .27.)
>>
>> On the second try -- with ramdisk.img -- I got it to boot to GUI, but
>> the GUI did not show up. I can hear the background sounds but not see
>> anything. I probably need to turn off
>> CONFIG_FRAMEBUFFER_CONSOLE... Yes, now it boots to the GUI and I can
>> actually see that. (It would be nice to make GUI work with
>> FRAMEBUFFER_CONSOLE on; it should not be that hard...).
>>
>
> It used to work, but I have not tested it recently. Make sure you turn
> CONFIG_FB_EARLYSUSPEND off and CONFIG_CONSOLE_EARLYSUSPEND on since
> userspace will not switch consoles if it finds the sysfs interface
> that CONFIG_FB_EARLYSUSPEND adds.

I fixed a bug in the framebuffer driver. If you pull the same branch
again it should work.

-- 
Arve Hjønnevåg
