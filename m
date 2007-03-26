Return-Path: <linux-kernel-owner+w=401wt.eu-S932900AbXCZHhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbXCZHhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 03:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbXCZHho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 03:37:44 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:35886 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbXCZHho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 03:37:44 -0400
Message-ID: <460776B2.3070404@student.ltu.se>
Date: Mon, 26 Mar 2007 09:30:58 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Lee Revell <rlrevell@joe-job.com>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] more scheduled OSS driver removal
References: <20070324130602.GD752@stusta.de> <4607213B.9070005@student.ltu.se> <75b66ecd0703252116m5216ec8dy78528f512ae63747@mail.gmail.com>
In-Reply-To: <75b66ecd0703252116m5216ec8dy78528f512ae63747@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:
> On 3/25/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>> Adrian Bunk wrote:
>> > This patch contains the scheduled removal of OSS drivers that:
>> > - have ALSA drivers for the same hardware without known regressions 
>> and
>> > - whose Kconfig options have been removed in 2.6.20.
>> >
>> Sorry for this late respond
>>
>> Is sound/oss/emu10k1/ really ready to be replaced? According to a friend
>> of mine, who got the hardware, the ALSA still lacks feature provided by
>> the OSS-driver. He mentioned some sort of programmable memory (forgot
>> the name for that) with whom you can run small programs to manipulate
>> the sounds (adding echo and such).
>
> He's referring to EMU DSP manager.  (emudspmgr I think it's called).
> The ALSA equivalent is ld10k1.  It might not be as mature as the OSS
> equivalent, but are we really going to keep obsolete drivers in the
> kernel just because the userspace tools for the old driver are more
> mature?
Good! I forward that info to him.
BTW, I did not mean to suggest we keep the OSS instead of ALSA. Just 
voiced if it is _ready_ to be replaced. But since there is no regression 
report filed (believed he already made one) I will pipe down :)
>
>> Also, he got problems with getting
>> more accurate control of the volume (guess this is more a userland 
>> issue).
>> He seems to have done his homework but only got to pages where other
>> peoples had the same problem.
>>
>
> I guess he's referring to the well known "Master volume only controls
> front output" problem.  This really does need to be resolved, as many
> other ALSA drivers are effected.
<rant_mode=on>
Isn't this quite a basic feature?! Is there somewhere to monitor the 
progress on this?
<rant_mode=off>

Thanks for your help!
Richard Knutsson

