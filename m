Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYHMUWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYHMUWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYHMUWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:22:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbYHMUWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:22:39 -0400
Message-ID: <48A34260.3070506@redhat.com>
Date: Wed, 13 Aug 2008 16:21:52 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
References: <20080813191926.GB15547@Krystal> <48A33D65.4020802@redhat.com> <20080813201532.GR1366@one.firstfloor.org>
In-Reply-To: <20080813201532.GR1366@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Aug 13, 2008 at 04:00:37PM -0400, Steven Rostedt wrote:
>   
>>> Now the numbers have shown that just by not using frame pointer (
>>> -pg right now implies frame pointer) you can get more benefit 
>>> than what you lose from using non optimal nops.
>>>  
>>>       
>> No, I can easily make a patch that does not use frame pointers but still 
>>     
>
> Not without patching gcc. Try it. The patch is not very difficult and i did
> it here, but it needs a patch. 
>   

OK, I admit you are right ;-)

I got the error message:

    gcc: -pg and -fomit-frame-pointer are incompatible

-- Steve

