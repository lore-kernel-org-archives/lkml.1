Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYGaBFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYGaBFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 21:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYGaBFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 21:05:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51730 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYGaBFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 21:05:32 -0400
Date: Wed, 30 Jul 2008 21:05:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: dump out ftrace buffers to console on panic
In-Reply-To: <20080730175640.f04f81b5.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807302103340.20120@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0807301700080.16138@gandalf.stny.rr.com> <20080730143028.a8e94161.akpm@linux-foundation.org> <alpine.DEB.1.10.0807302020590.19138@gandalf.stny.rr.com> <20080730175640.f04f81b5.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 30 Jul 2008, Andrew Morton wrote:
>>
>> I don't mind making it unconditionally available. I only added the config
>> option because I thought people would like to turn it off.
>>
>> I'll resubmit with the above concerns fixed and without the config option.
>
> Well..  my question about the config option was no more than a question
> - I don't know the answer.
>
> Although thinking about it, I guess that anyone who is really squeezy
> on space just won't be enabling ftrace at all.  Is there any reason
> other than size for disabling this new feature?

Just the output to the console on oops. But then again, it only prints a 
lot if ftrace has stuff in the buffers.

I also lowered the count to keep the pain down when this was configured, 
but since the size of the buffers is both boot time and run time 
configurable, it shouldn't be a problem. If people want more buffer space, 
they simply need to increase it at run time.

-- Steve
