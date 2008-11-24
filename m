Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYKXTNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYKXTNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYKXTNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:13:14 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:40640 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYKXTNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:13:13 -0500
Message-ID: <492AFCC3.4090602@birkenwald.de>
Date: Mon, 24 Nov 2008 20:13:07 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Romano Giannetti (lists)" <romanol@upcomillas.es>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andreas Mohr <andi@lisas.de>,
       devsk <kernel-bugs.dev1world@spamgourmet.com>,
       Johan Bilien <jobi@via.ecp.fr>
Subject: Re: [Bug #11947] 2.6.28-rc VC switching with Intel graphics broken
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.IHD.O8HKJB@chimera> <492A6A20.4080106@upcomillas.es> <200811241101.55121.jbarnes@virtuousgeek.org>
In-Reply-To: <200811241101.55121.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> On Monday, November 24, 2008 12:47 am Romano Giannetti (lists) wrote:
>> Rafael J. Wysocki wrote:
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11947
>>> Subject		: 2.6.28-rc VC switching with Intel graphics broken
>>> Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
>>> Date		: 2008-11-03 12:10 (20 days old)
>>> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Still with us on -rc6, nasty, reproducible, no clues on what can be.
>>
>> VC switch locks or delay the systems minutes, resuming from suspend locks
>> hard the machine.
>>
>> 2.6.28-rc is unusable here.
>>
>> Jesse, any hints? My suspicion that it can be the same thing happened with
>> bug 10620 is wrong? (It was a very similar error about vblank...)
> 
> Just added to the bug, it looks like a DUP of an issue Keith just fixed last 
> week (now to make sure the patch makes it upstream quickly).

I can confirm that, with the patch from 
http://lists.freedesktop.org/archives/intel-gfx/2008-November/000614.html 
applied on top of current git head (rejected hunk in 
drivers/gpu/drm/i915/915_irq.c due to the additional 
dev_priv->irq_mask_reg = ~0; in git between the removed lines, I kept 
it) I can suspend/resume and do a VC switch again.

Big thanks!

Bernhard
