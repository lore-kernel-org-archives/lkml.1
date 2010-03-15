Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393Ab0COHqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:46:47 -0400
Received: from mail1.perex.cz ([212.20.107.53]:34728 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933904Ab0COHqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:46:46 -0400
Date: Mon, 15 Mar 2010 08:46:44 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.34-rc1: regression: ^Z no longer stops sound
In-Reply-To: <20100315074132.GB8886@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.LNX.2.00.1003150843530.4672@eeebox2.perex-int.cz>
References: <20100314075831.GA13457@elf.ucw.cz> <s5hhboijb83.wl%tiwai@suse.de> <20100315074132.GB8886@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010, Pavel Machek wrote:

>> At Sun, 14 Mar 2010 08:58:31 +0100,
>> Pavel Machek wrote:
>>>
>>> Hi!
>>>
>>> In 2.6.33, hitting ^Z stopped mpg123 in a way you'd expect (both on
>>> thinkpad and geode notebook).
>>>
>>> On 2.6.34-rc1, hit ^Z and sound starts looping.
>>
>> Is it an OSS app using the kernel OSS emulation or another backend?
>
> OSS kernel emulation, yes. ... at least I think I'm using it.

I cannot reproduce this problem here. Could you post the contents
of /proc/asound/card0/pcm0p/sub0/status file when you stop the 
audio process and looping starts?

 				Thanks,
 					Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

