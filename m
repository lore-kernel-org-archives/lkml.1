Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbZAOMHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbZAOMHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZAOMG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:06:58 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:59966 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395AbZAOMG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:06:57 -0500
Message-ID: <496F26F3.2030302@xyzw.org>
Date: Thu, 15 Jan 2009 04:07:15 -0800
From: Brian Rogers <brian@xyzw.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] How to get real-time priority using idle priority
References: <4969D0D7.2060401@xyzw.org>	 <1231736941.6003.7.camel@marge.simson.net>	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>	 <496BE8F6.1040308@xyzw.org> <1232011723.26761.36.camel@marge.simson.net>
In-Reply-To: <1232011723.26761.36.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Mon, 2009-01-12 at 17:05 -0800, Brian Rogers wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> i've applied your fix to tip/sched/urgent and merged it into tip/master.
>>> Brian, you might want to test tip/master, as per:
>>>
>>>  http://people.redhat.com/mingo/tip.git/README
>>>
>>> which now has this fix included. Can you make it break?
>>>       
>> Yeah, I was able to trigger the same freeze again once on my desktop, 
>> but it appears to be harder to trigger now. I couldn't get my program to 
>> freeze the system, but one of the times I suspended then resumed BOINC, 
>> it happened.
>>     
> OK, the below seems to cure all of the problems I've encountered, please
> take it out for a spin.
>   
This did the trick! I can't make it freeze anymore, with BOINC or with 
forkdie, and the system remains responsive even with dozens of idle 
priority tasks hogging all spare CPU time. It's great!

