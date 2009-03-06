Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbZCFOuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbZCFOuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZCFOuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:50:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43361 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbZCFOuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:50:02 -0500
Message-ID: <49B137F7.9040207@redhat.com>
Date: Fri, 06 Mar 2009 09:49:27 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] x86: make text_poke() atomic using fixmap
References: <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu> <49AC7453.8020307@redhat.com> <20090303002214.GA4147@elte.hu> <49AC7A5F.7080009@redhat.com> <49AD5B55.10002@redhat.com> <20090305103852.GD32407@elte.hu> <20090306140612.GA8566@elte.hu>
In-Reply-To: <20090306140612.GA8566@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
>>
>>> Hi Ingo,
>>>
>>> Here is the patch which uses fixmaps instead of vmap in 
>>> text_poke(). This made the code much simpler than I thought 
>>> :).
>> Looks good to me at a quick glance albeit Linus had second 
>> thoughts about using fixmaps for this in the past. But with 
>> delayed-flush for vmaps i think fixmaps are again the simpler 
>> and more robust - albeit more limited - choice ...
>>
>> In any case, the x86 tree already unified fixmap.h so could 
>> you please resend the whole series as a 0/3, 1/3, 2/3, 3/3 
>> thing against tip:master, starting a new thread on lkml? (this 
>> thread is already way too deep)
> 
> Ping? I think there's agreement and it would be nice to fix this 
> in .30. Looks too complex for .29 - maybe backportable to .29.1 
> if it stays problem-free in testing.

Sorry for later, I'll post it as soon as possible.

> 
> 	Ingo

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

