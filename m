Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbZFLDWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbZFLDWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZFLDWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:22:07 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:49036 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZFLDWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:22:06 -0400
Message-ID: <4A31C9D6.7070707@davidnewall.com>
Date: Fri, 12 Jun 2009 12:51:58 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
References: <20090611160329.GA3366@elte.hu>  <20090611161714.GA5008@infradead.org>  <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>  <20090611165226.GV8633@ZenIV.linux.org.uk>  <1244739378.6691.540.camel@laptop>  <20090611170015.GA3651@infradead.org>  <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com> <4A3148AA.9000007@davidnewall.com> <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain> <4A314F37.2080202@davidnewall.com> <alpine.LFD.2.01.0906111142390.3573@localhost.localdomain> <4A3155E3.3030603@davidnewall.com> <alpine.LFD.2.01.0906111223250.3573@localhost.localdomain> <alpine.LFD.2.01.0906111226130.3573@localhost.localdomain> <4A315C9F.8050908@davidnewall.com> <alpine.LFD.2.01.0906111247270.3535@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906111247270.3535@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 12 Jun 2009, David Newall wrote:
>> Linus Torvalds wrote:
>>     
>>> To take the oprofile example that decided it for me: the code to actually 
>>> support new processors was all done by basically kernel developers. And it 
>>> didn't hit user land for almost a year, because the user-land tools didn't 
>>> take the patch and propagate it up.
>>>       
>> Bad developer, Spot, you only did half the job. Not sure there's much
>> more one can say.
>>     
>
> Umm. The kernel developer _did_ do the job. The patch to the user land 
> side was available for that whole year.

I don't know this oprofile problem you had, only what you've said, which
is that somebody* did the kernel bit and somebody else did the userspace
bit; and the person doing the userspace bit was unresponsive so good
stuff got ignored for a year. That situation did not occur because the
userspace was out-of-tree, it occurred because you let it. You could
have given the userspace (back) to the kernel developer. That's what
you'd eventually do if a kernel sub-system maintainer became
unresponsive, isn't it?

*the singular is intended to include the plural and the male to include
female.


> Anyway, it's clearly not worth discussing this with you. I've tried. I 
> give up. Happily, I don't _need_ to convince you.

Indeed, no, you don't need to convince me, particularly as I've made it
abundantly clear that I'm entirely happy with your decision. Notice I've
not argued with you, merely pointed out inconsistencies in what you've
said. I realise that can be annoying, and acknowledge your absolute
right to be as consistent or inconsistent as you choose. I wasn't (and
still aren't) trying to be annoying, but to confirm there was no
confusion. If you hadn't seen these inconsistencies before, you surely
do now. That actually should be worth your while. I personally welcome
being corrected; andconsider that a trait of an open mind.
