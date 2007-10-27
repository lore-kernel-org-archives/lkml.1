Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbXJ0OpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbXJ0OpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXJ0OpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:45:06 -0400
Received: from smtp4.netcabo.pt ([212.113.174.31]:59195 "EHLO
	exch01smtp09.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbXJ0OpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:45:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAJnrIkdViqaH/2dsb2JhbAAMkDw
Message-ID: <47234EA1.4050006@rncbc.org>
Date: Sat, 27 Oct 2007 15:43:45 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.23-rt4 (was 2.6.23-rt1 trouble)
References: <1192154640.15992.10.camel@localhost.localdomain>          <38542.213.58.131.130.1192445349.squirrel@www.rncbc.org> <471648B8.1030007@rncbc.org>
In-Reply-To: <471648B8.1030007@rncbc.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2007 14:45:02.0526 (UTC) FILETIME=[F4C5ADE0:01C818A7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, October 15, 2007 11:49, Rui Nuno Capela wrote:
>>
>> I am experiencing some highly annoying but intermitent freezing on a
>> pentium4 2.80G HT/SMT box, when doing normal desktop work with 2.6.23-rt1.
>>
>>
>> The same crippling behavior does not occur on a Core 2 Due T7200 2.0G
>> SMP, so I suspect it's something due specific to the SMT scheduling
>> support (Hyper-Threading). But can't tell for sure, obviously :)
>>
> 
> I was wrong. After several trials the same behavior also occurs on the
> Core2 Duo T7200. It just took longer to show its nasty.
> 
> 
>> The symptoms are noticeable primarily as some X/GUI intermitent freezing,
>> sometimes only one application, then several and ultimately the whole X 
>> desktop becomes completely unresponsive. It looks like scheduling 
>> problems. There is this hint that switching to a spare console terminal 
>> (via Ctrl+Alt+Fn) might cause later recovery. But its just a question of
>> some more time for it just happens again and again, one after another, 
>> several applications becoming temporarily frozen and just by luck the 
>> system gets back to normal, probably due to some incidental shake-up :) 
>> but there are other times that nothing seems to help with no alternative 
>> to the power-reset switch.
>>
>> I could not find any evidence on dmesg or in the system logs, of any
>> apparent trouble. No BUGs, no oops, no panics, no nothing. It just
>> freezes, this and that, now and then. It just makes it all unworkable
>> and obviously subject to ditching.
>>
>> Again, this only happens on this P4/HT box. On a Core2 Duo laptop, with
>> same 2.6.23-rt1 with the very same kernel configuration, it does not show 
>> any illness and is running quite fine.
>>
> 
> False. It used to run fine, until the creeps happen first time :(
> 
> 
>> Remember one report I had about a similar freezing behavior? Now it's
>> happening the other way around: the core2 is OK, the pentium4 is KO.
>>
> 
> Now it applies to all 2.6.23-rt1 images I could test upon.
> 
> 
>> One naive suspicion goes like the new rcu-preempt code is to blame, since
>> I don't remember having this or any other trouble with 2.6.23-rc8-rt1.
>>
> 
> Not be sure anymore, but this seems to be still a valid assumption.
> 

just to let you know that still the same trouble persists with 2.6.23.1-rt4

.config can be found here:
   http://www.rncbc.org/datahub/config-2.6.23.1-rt4.0


cheers.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
