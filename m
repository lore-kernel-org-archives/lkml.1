Return-Path: <linux-kernel-owner+w=401wt.eu-S933833AbZFLK21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833AbZFLK21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760066AbZFLK2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:28:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50623 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764327AbZFLK2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:28:15 -0400
Date: Fri, 12 Jun 2009 12:28:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090612102804.GA15914@elte.hu>
References: <20090611160329.GA3366@elte.hu> <7c86c4470906120256m545363d4h85a3e84a88291ac7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906120256m545363d4h85a3e84a88291ac7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* stephane eranian <eranian@googlemail.com> wrote:

> Hi,
> 
> On Thu, Jun 11, 2009 at 6:03 PM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > The counter concept got objected to in past discussions on lkml, 
> > by DaveM and by Stephane Eranian (i've Cc:-ed them) - so this 
> > code was not eligible for linux-next testing - nevertheless we 
> > gave it good testing on PowerPC and x86 and i've done a wide 
> > cross-build test as well to try to make sure it breaks no other 
> > architecture.
> 
> I don't think you can quote me saying "I object to this code". 
> [...]

I never saw you retract/change this negative opinion of yours about 
the whole separate-counters concept:

  " In summary, although the idea of simplifying tools by moving the 
    complexity elsewhere is legitimate, pushing it down to the 
    kernel is the wrong approach in my opinion, perfmon has avoided 
    that as much as possible for good reasons. "

    http://lkml.org/lkml/2008/12/5/359

Do you like the concept now? That would be great news - you have a 
lot of experience with various PMU details and we could certainly 
welcome help with the perf tool and with the kernel side of 
perfcounters!

> [...]  I posted a detailed review of the API and implementation on 
> X86 outlining lots of issues. Some got fixed, but many others are 
> left unresolved at this point. And I will post some more shortly.

Hm, Peter replied to you mail a week ago, in detail. We addressed a 
good number of issues pointed out by you, and we credited you for 
them:

earth4:~/tip> git log v2.6.30..linus | grep 'Reported-by: Stephane Eranian'
    Reported-by: Stephane Eranian <eranian@googlemail.com>
    Reported-by: Stephane Eranian <eranian@googlemail.com>
    Reported-by: Stephane Eranian <eranian@googlemail.com>
    Reported-by: Stephane Eranian <eranian@googlemail.com>
    Reported-by: Stephane Eranian <eranian@googlemail.com>
    Reported-by: Stephane Eranian <eranian@googlemail.com>
    Reported-by: Stephane Eranian <eranian@googlemail.com>

You were on the Cc: of the commit notifications. If you see issues 
left unaddressed after reply+commit please repeat it - it probably 
just got lost in noise.

> I don't think that because this code is coming from you, it should 
> be allowed to short-circuit the established release process. You 
> have to respond to questions, fix issues like everybody else and 
> if that slows down the integration you cannot blame the reviewers 
> for it.

There's three maintainers of perfcounters: Peter Zijlstra, Paul 
Mackerras and me - and if some real problem missed the attention of 
all of us then please repeat it - it probably was just missed in a 
bigger mail or so. I certainly dont remember anything major. We 
generally try to reply to any and all feedback.

Thanks,

	Ingo
