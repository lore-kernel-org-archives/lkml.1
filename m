Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbXH2WeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbXH2WeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1749667AbXH2WeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:34:01 -0400
Received: from mail.tmr.com ([64.65.253.246]:35835 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXH2WeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:34:00 -0400
Message-ID: <46D5F45C.7020800@tmr.com>
Date: Wed, 29 Aug 2007 18:34:04 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Ivan N. Zlatev" <contact@i-nz.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/4] 2.6.23-rc4: known regressions
References: <46D58CC6.4020605@googlemail.com>	<46D59052.6040609@googlemail.com>	<3db1ec7f0708290842y176c48eck9f39131a107756f9@mail.gmail.com> <s5hodgqibf8.wl%tiwai@suse.de>
In-Reply-To: <s5hodgqibf8.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Wed, 29 Aug 2007 18:42:56 +0300,
> Ivan N. Zlatev wrote:
>> On 8/29/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>>> ALSA
>>>
>>> Subject         : Master volume control broken
>>> References      : http://lkml.org/lkml/2007/8/18/46
>>> Last known good : ?
>>> Submitter       : Thomas Meyer <thomas@m3y3r.de>
>>> Caused-By       : Ivan N. Zlatev <contact@i-nz.net>
>>>                   commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1
>>> Handled-By      : Ivan N. Zlatev <contact@i-nz.net>
>>> Status          : problem is being debugged
>>>
>>>
>> Hello,
>>
>> I am not the one to handle the issue. I have just supplied the
>> pinconfigs for the intel mac cards and assisted with logs/debug
>> information, so I happen to be more of an end user. I am not familiar
>> with the code base of the Intel HDA Codec. Takashi Iwai is the one
>> with the knowledge to fix the problem.
> 
> ... but without the hardware :-<
> 
> IMO, this is actually no real regression.  In the earlier verison, you
> didn't have controls for multiple outputs, thus the mixer control was
> named as Master.  Now you do have multiple individual controls, and
> thus there is no master any more, instead.  That's the trade-off.
> 
Would you buy or use a stand-alone mixer where the only way to control 
total output would be to change the setting for one output, then 
rebalance all the others against it, and then iterate until the result 
is correct?

Is this an intermediate step to the full functionality of a $29 Radio 
Shack mixer, or a limitation of just one audio driver, or maybe the user 
interface for ALSA is broken right now?

Is it planned to leave Linux audio in this state?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
