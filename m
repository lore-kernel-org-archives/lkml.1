Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbXJBVUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbXJBVUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbXJBVU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:20:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672AbXJBVUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:20:24 -0400
Date: Tue, 2 Oct 2007 14:20:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Davidsen <davidsen@tmr.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
   Control Kernel
In-Reply-To: <4702B1D5.5050502@tmr.com>
Message-ID: <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
References: <46FEEBD4.5050401@schaufler-ca.com>  <20070930011618.ccb8351b.akpm@linux-foundation.org>
  <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> 
 <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
 <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
 <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
 <4702B1D5.5050502@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Oct 2007, Bill Davidsen wrote:
>
> And yet you can make the exact same case for schedulers as security, you can
> quantify the behavior, but if your only choice is A it doesn't help to know
> that B is better.

You snipped a key part of the argument. Namely:

  Another difference is that when it comes to schedulers, I feel like I
  actually can make an informed decision. Which means that I'm perfectly
  happy to just make that decision, and take the flak that I get for it. And
  I do (both decide, and get flak). That's my job.

which you seem to not have read or understood (neither did apparently 
anybody on slashdot).

> You say "performance" as if it had universal meaning.

Blah. Bogus and pointless argument removed.

When it comes to schedulers, "performance" *is* pretty damn well-defined, 
and has effectively universal meaning.

The arguments that "servers" have a different profile than "desktop" is 
pure and utter garbage, and is perpetuated by people who don't know what 
they are talking about. The whole notion of "server" and "desktop" 
scheduling being different is nothing but crap. 

I don't know who came up with it, or why people continue to feed the 
insane ideas. Why do people think that servers don't care about latency? 
Why do people believe that desktop doesn't have multiple processors or 
through-put intensive loads? Why are people continuing this *idiotic* 
scheduler discussion?

Really - not only is the whole "desktop scheduler" argument totally bogus 
to begin with (and only brought up by people who either don't know 
anything about it, or who just want to argue, regardless of whether the 
argumen is valid or not), quite frankly, when you say that it's the "same 
issue" as with security models, you're simply FULL OF SH*T.

The issue with LSM is that security people simply cannot even agree on the 
model. It has nothing to do with performance. It's about management, and 
it's about totally different models. Have you even *looked* at the 
differences between AppArmor and SELinux? Did you look at SMACK? They are 
all done by people who are interested in security, but have totally 
different notions of what "security" even *IS*ALL*ABOUT.

In contrast, anybody who claims that the CPU scheduler doesn't know what 
it's all about is just tripping. And anybody who claims that desktop 
workloads are so radically different from server workloads (or that the 
hardware is so different) is just totally out to lunch.

So next time, think five minutes before you start your argument.

			Linus
