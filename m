Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbYEYTa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbYEYTa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbYEYTab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:30:31 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3806 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369AbYEYTa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:30:29 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Date: Sun, 25 May 2008 21:30:01 +0200
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505171501.GA22332@elte.hu>
In-Reply-To: <20080505171501.GA22332@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805252130.05995.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 5. May 2008, Ingo Molnar wrote:

> This is a many years old kconfig bug that is frequently hacked around in
> distro kernel packages but which has been ignored upstream - i've
> attached Fedora's nonint_oldconfig patch from Dave Jones below. (maybe
> Arjan wrote it originally?)

Ingo, I would really appreciate if you stopped your kconfig bashing.
I haven't ignored this patch, if you only did a little bit of research you 
might have found http://lkml.org/lkml/2004/6/1/170, where I commented on this 
patch.
It seems for you it's more important to reclassify a feature request as "bug" 
and adding your own little half truth, just so you can harass me. If you 
think there is a bug somewhere, you are free to submit them as such and I'm 
happy to explain, if and how that bug can be fixed.

I considered to let this (and others) slide, but this latest example 
http://lkml.org/lkml/2008/5/20/473 doesn't suggest that you'll going to stop.
It looks innocent enough to the casual reader, so let's look at it a little 
closer.
First you don't even bother to Cc me, although I doubt you don't know that I 
wrote it and thus is responsible for it. Due to the lkml volume I don't read 
everything, often even with a few days delay and I would have missed this one 
if Sam hadn't pointed me to it.
Secondly, it's amazing how you get to your conclusion. You create your own 
reality by omitting anything that doesn't fit into it, only a few days 
earlier I said in 
http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2454.html that select 
isn't really the main problem (you were even in the Cc). You are of course 
free to disagree with this, but you nowhere seem to acknowledge, that this 
has somehow arrived in your own little reality.
You don't even show the smallest amount of doubt, for you it's clear that 
kconfig is buggy, no questions are needed. If you want to make such 
pronouncement, you should also do the necessary research, which includes a 
look at other possible solutions. If you don't want to or can't do this 
research (which isn't a problem itself), I would expect questions, but you 
don't need this, you are apparently the new kconfig expert, who can proclaim 
what is and isn't a bug and how it has to be fixed.

I would have ignored this if it only happened once or twice, but this pattern 
of yours is too persistent to be ignored. What makes this so perfid, is that 
the casual reader doesn't immediately see this as a problem, since you only 
show half the picture, omitting anything that doesn't fit your conclusion. 
Everyone can make such mistake, but if it happens repeatedly despite having 
different information it's becoming bullying (independent of whether it's 
done intentionally or not). This is a rather sneaky strategy, where you don't 
make your hands dirty directly, but still every little stab leaves behind an 
impression, which adds up. It does nothing but destroying my reputation, I'm 
now the one who is complaining, which others soon probably like to describe 
as "whining", which more often lately just means that he doesn't like what 
someone has to say. I can only loose either way, either you continue your 
little backstabbing or I have to complain about these (where not everyone 
sees the complete picture from a single mail). If I should fix this properly 
then you can claim it had been done due to your "persistence", but let me 
assure you that this is doing nothing to encourage me to do anything about 
this. It rather encourages me to spent my time on other things, which are 
more fun and as I'm not paid to do this, I'm not forced to take this level of 
masochism, so if it's your goal to get rid of me, then please say so clearly.

bye, Roman
