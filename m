Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZDPA2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZDPA2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZDPA1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:27:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158AbZDPA1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:27:50 -0400
Date: Wed, 15 Apr 2009 17:23:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <20090416000841.GA18185@elte.hu>
Message-ID: <alpine.LFD.2.00.0904151717040.4042@localhost.localdomain>
References: <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
 <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain> <20090415224017.GA18764@elte.hu> <alpine.LFD.2.00.0904151607010.4042@localhost.localdomain>
 <20090416000841.GA18185@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Ingo Molnar wrote:
> 
> Is there any other way for us to get the benefits of the impact 
> line, without actually adding one?
> 
> They are:
> 
>  - Better split-up patches from contributors.
> 
>  - Increased maintainer and developer attention on the effects of
>    patches.
> 
>  - Less time we have to spend on patches we get with impact-lines.
>    Both hpa and me reported this.
> 
>  - easy regression post-mortems

None of this has anything to do with "Impact:" per se, and everything to 
do with just trying to tach people to talk about their patches better.

By all means, when you see a patch that doesn't describe what it does or 
why it does so, ask people to say so.

Ask people "What's the impact of this patch?"

But don't ask them to then say

	Impact: cleanup.

Teach them to say

	This cleans up the code by doing xyz.

and yes, by all means teach people to write succint and to-the-point 
messages.

Teach people to not write a novel, but instead give them rules like:

 - the subject line has to descibe the over-all patch.

 - Then write a line or two that is about what the patch really does

 - if needed, write a longer detailed explanation with actual error 
   messages that it fixes etc.

Now THAT is somethign that I think we can all get behind. Example of a 
good patch log:

    kprobes: move EXPORT_SYMBOL_GPL just after function definitions
    
    Clean up positions of EXPORT_SYMBOL_GPL in kernel/kprobes.c according to
    checkpatch.pl.

wouldn't you agree? Adding a "Impact: cleanup" wouldn't do anything to it, 
except make it not read as good English any more.

I like seeing explanations that read well. 

			Linus
