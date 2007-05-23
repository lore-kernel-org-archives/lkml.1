Return-Path: <linux-kernel-owner+w=401wt.eu-S1761657AbXEWQ5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657AbXEWQ5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbXEWQ5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:57:46 -0400
Received: from mail.tmr.com ([64.65.253.246]:44669 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613AbXEWQ5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:57:45 -0400
Message-ID: <465472DE.1020804@tmr.com>
Date: Wed, 23 May 2007 12:59:10 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Miguel Figueiredo <elmig@debianpt.org>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com> <46534C31.1060306@debianpt.org> <46538AB8.8030009@tmr.com> <200705241036.45179.kernel@kolivas.org>
In-Reply-To: <200705241036.45179.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Wednesday 23 May 2007 10:28, Bill Davidsen wrote:
>   
>>> kernel    2.6.21-cfs-v13    2.6.21-ck2
>>> a)    194464        254669
>>> b)    54159        124
>>>       
>> Everyone seems to like ck2, this makes it look as if the video display
>> would be really pretty unusable. While sd-0.48 does show an occasional
>> video glitch when watching video under heavy load, it's annoying rather
>> than unusable.
>>     
>
> That's because the whole premise of your benchmark relies on a workload that 
> yield()s itself to the eyeballs on most graphic card combinations when using 
> glxgears. Your test remains a test of sched_yield in the presence of your 
> workloads rather than anything else. If people like ck2 it's because in the 
> real world with real workloads it is better, rather than on a yield() based 
> benchmark. Repeatedly the reports are that 3d apps and games in normal usage 
> under -ck are better than mainline and cfs.
>   
I have to admit that I call in the teen reserves to actually get good 
feedback on games, but I do watch a fair number of videos and under high 
load I find sd acceptable and cfs totally smooth. The next time my game 
expert comes to visit I'll get some subjective feedback. My use of 
glxgears was mainly intended to use something readily available, and 
which gave me the ability to make both subjective and objective evaluations.

My -ck2 results certainly show no significant difference from sd-0.48, I 
suspect that on a machine with less memory the swap reload would be more 
beneficial.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

