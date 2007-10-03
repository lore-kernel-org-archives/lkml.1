Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbXJCDsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbXJCDsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 23:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXJCDsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 23:48:31 -0400
Received: from mail.tmr.com ([64.65.253.246]:37842 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXJCDsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 23:48:30 -0400
Message-ID: <4703126D.70703@tmr.com>
Date: Tue, 02 Oct 2007 23:54:21 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
   Control Kernel
References: <46FEEBD4.5050401@schaufler-ca.com>  <20070930011618.ccb8351b.akpm@linux-foundation.org>  <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>  <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org> <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil> <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org> <4702B1D5.5050502@tmr.com> <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 2 Oct 2007, Bill Davidsen wrote:
>   
>> And yet you can make the exact same case for schedulers as security, you can
>> quantify the behavior, but if your only choice is A it doesn't help to know
>> that B is better.
>>     
>
> You snipped a key part of the argument. Namely:
>
>   Another difference is that when it comes to schedulers, I feel like I
>   actually can make an informed decision. Which means that I'm perfectly
>   happy to just make that decision, and take the flak that I get for it. And
>   I do (both decide, and get flak). That's my job.
>
> which you seem to not have read or understood (neither did apparently 
> anybody on slashdot).
>   

Actually I had quoted that, made a reply, and decided that my reply was 
too close to a flame and deleted the quote and the nasty reply, because 
I couldn't find a nice way to say what I wanted. Oh well, I tried to 
keep to a higher level, but... on this topic you seem to be off on an 
ego trip. You are not the decider, George Bush is the decider, and the 
only time he's not wrong he didn't understand the question. I checked 
the schedule, it's not you week to be God.

There are sensible people you respect on other topics, who have the 
opinion that there is room for behaviors other than CFS, and who have 
created a pluggable scheduler framework which they are trying to hand 
you on a platter. And you won't even consider that they might be right, 
because you believe there can be one scheduler which is close to optimal 
for all loads.
>> You say "performance" as if it had universal meaning.
>>     
>
> Blah. Bogus and pointless argument removed.
>
> When it comes to schedulers, "performance" *is* pretty damn well-defined, 
> and has effectively universal meaning.
>
> The arguments that "servers" have a different profile than "desktop" is 
> pure and utter garbage, and is perpetuated by people who don't know what 
> they are talking about. The whole notion of "server" and "desktop" 
> scheduling being different is nothing but crap. 
>   

Unfortunately not so, I've been looking at schedulers since MULTICS, and 
desktops since the 70s (MP/M), and networked servers since I was the 
ARPAnet technical administrator at GE's Corporate R&D Center. And on 
desktops response is (and should be king), while on a server, like nntp 
or mail, I will happily go from 1ms to 10sec for a message to pass 
through the system if only I can pass 30% more messages per hour, 
because in virtually all cases transit time in that range is not an 
issue. Same thing for DNS, LDAP, etc, only smaller time range. If my 
goal is <10ms, I will not sacrifice capacity to do it.
> I don't know who came up with it, or why people continue to feed the 
> insane ideas. Why do people think that servers don't care about latency? 
>   

Because people who run servers for a living, and have to live with 
limited hardware capacity realize that latency isn't the only issue to 
be addressed, and that the policy for degradation of latency vs. 
throughput may be very different on one server than another or a desktop.
> Why do people believe that desktop doesn't have multiple processors or 
> through-put intensive loads? Why are people continuing this *idiotic* 
> scheduler discussion?
>   

Because people can't get you to understand that one size doesn't fit all 
(and I doubt I've broken through).
> Really - not only is the whole "desktop scheduler" argument totally bogus 
> to begin with (and only brought up by people who either don't know 
> anything about it, or who just want to argue, regardless of whether the 
> argumen is valid or not), quite frankly, when you say that it's the "same 
> issue" as with security models, you're simply FULL OF SH*T.
>   

The real issue is that you can't imagine that people who don't share 
your opinion are not only wrong but don't understand the problem. You 
may be right, but when you say anyone who disagrees is wrong by 
definition, then you have lost sight of productive technical 
differences. When your arguments drop to personal attacks and rants it's 
time to look at your technical values.
> The issue with LSM is that security people simply cannot even agree on the 
> model. It has nothing to do with performance. It's about management, and 
> it's about totally different models. Have you even *looked* at the 
> differences between AppArmor and SELinux? Did you look at SMACK? They are 
> all done by people who are interested in security, but have totally 
> different notions of what "security" even *IS*ALL*ABOUT.
>   

Exactly, and I'm not the only one who doubts that more than one model 
would be useful. I'm sorry you can't see that about CPU schedulers as well.
> In contrast, anybody who claims that the CPU scheduler doesn't know what 
> it's all about is just tripping. And anybody who claims that desktop 
> workloads are so radically different from server workloads (or that the 
> hardware is so different) is just totally out to lunch.
>
> So next time, think five minutes before you start your argument.
>   

I don't disagree with you lightly, in this case I think I have a better 
superficial understanding of schedulers than you do of how production 
servers are used.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

