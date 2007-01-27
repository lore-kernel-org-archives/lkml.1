Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbXA0KVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbXA0KVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 05:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXA0KVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 05:21:43 -0500
Received: from weequay.is.scarlet.be ([193.74.71.24]:36885 "EHLO
	weequay.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbXA0KVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 05:21:42 -0500
Message-ID: <45BB272F.3020508@joow.be>
Date: Sat, 27 Jan 2007 11:19:27 +0100
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lee Revell <rlrevell@joe-job.com>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: status of: tasklet_unlock_wait() causes soft lockup with -rt
 and ieee1394	audio
References: <1152371924.4736.169.camel@mindpipe> <45B3F7A5.2050708@joow.be> <20070122091035.GA11821@elte.hu>
In-Reply-To: <20070122091035.GA11821@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: weequay 20001; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Pieter Palmers <pieterp@joow.be> wrote:
> 
>> Dear all,
>>
>> What is the status with respect to this problem? I see that in the 
>> current -rt patch the problematic code piece is different. I 
>> personally haven't tried to reproduce this myself on a more recent 
>> kernel, but I just got a report from one of our users who experienced 
>> the same problem with 2.6.19-rt15 and RT preemption (desktop 
>> preemption works fine).
>>
>> Should the latest -rt patches be fixed with respect to this issue? If 
>> so I'll try and test them, otherwise I omit the effort.
> 
> it's not fixed yet. Could you try the patch below?

I just compiled & installed 2.6.20-rc6-rt2, and I saw that this patch 
was in the -rt2 patch, so I gave real-time preemption a shot. It seems 
to work, I don't experience lockups anymore.

Thanks for the fix,

Pieter
