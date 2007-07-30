Return-Path: <linux-kernel-owner+w=401wt.eu-S939000AbXG3J0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939000AbXG3J0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933839AbXG3J0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:26:24 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:2896 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763702AbXG3J0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S5fU10r3/3KGYQN77TIDuDvM0evYpJb+gdiazJNxXJVNzW3wgfkchkDIA169NAAQhmS3CSl/TKKZVDAxHZj1aUmtQhNOrIbjnWCLokeCFW49D6bsiBR66LwLi8SV9UpR9LCfeydPZkdr3a1XJhIEl2ZPPhSStYarIqHh/XYLE+Q=
Message-ID: <a12e280d0707300226y71d47b04t86000abb6a082c30@mail.gmail.com>
Date: Mon, 30 Jul 2007 19:26:20 +1000
From: "George Sescher" <gesacs@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Linus 2.6.23-rc1
Cc: "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "CK Mailinglist" <ck@vds.kolivas.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>
In-Reply-To: <20070730075528.GA1806@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu>
	 <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
	 <20070730064423.GA30505@elte.hu>
	 <a12e280d0707300006l52a695bcy9912ee2689d6f636@mail.gmail.com>
	 <20070730075528.GA1806@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> * George Sescher <gesacs@gmail.com> wrote:
>
> > > > On 30/07/07, Ingo Molnar <mingo@elte.hu> wrote:
> > > > > i'd encourage you to do it - in fact i already tried to prod Peter
> > > > > Williams into doing exactly that ;) The more reality checks a
> > > > > scheduler has, the better. [ Btw., after the obvious initial merging
> > > > > trouble it should be much easier to keep SD maintained against
> > > > > future upstream kernels due to the policy modularity that CFS
> > > > > introduces. (and which policy-modularity should also help reduce the
> > > > > size and complexity of the SD patch.) ]
> >
> > > * George Sescher <gesacs@gmail.com> wrote:
> > > > <chuckle>
> > > >
> > > > You're advocating plugsched now?
> >
> > On 30/07/07, Ingo Molnar <mingo@elte.hu> wrote:
> > > hm, the way you posited this question implies that you see an
> > > inconsistency in my position or that it surprised you - i cannot explain
> > > the '<chuckle>' in any other way :) Which bit do you see as inconsistent
> > > and/or which bit surprised you and why?
> >
> > The idea is not good enough for mainline and has no place in mainline
> > yet you say it's very important to maintain it... but out of mainline.
> > Place the responsibility of keeping mainline's performance in check
> > "reality check as you called it" on to someone who is forced to
> > develop out of mainline? I have zero interest one way or the other
> > myself, but how can one not chuckle?

On 30/07/07, Ingo Molnar <mingo@elte.hu> wrote:
> What you should realize is that _all_ future code that goes into Linux
> is 'forced' to be developed 'out of mainline' today. So what you seem to
> characterise via negative terms like 'forced', and what seems to make
> you 'chuckle' (not meant as a compliment either i gather ;), is in fact
> the _very engine_ that keeps Linux running.
>
> And there's no exception: Linus himself creates an "out of mainline"
> fork of Linux every time he develops something new. "Forks" are _the_
> main mechanism to develop Linux, and it always was. External code is the
> "reality check" of mainline code. It is the 'external pool of genes'
> that is _competing_ against in-tree code.
>
> Sometimes the decision to include new bits of code is easy and positive
> (so it is a "fork" only very briefly and nobody actually ever has enough
> time to think of that code as a "fork"), sometimes it takes some time
> and the decision is positive, sometimes the decision is immediately
> negative and the code is rejected, sometimes it's negative after some
> time. Often code goes through several cycles of rejection before it is
> merged. The larger the code, the more rejections it will see - and that
> is natural. Sometimes, very rarely, out of the hundreds of thousands of
> external changes that went into Linux so far, code seems to be staying
> 'in limbo' forever - such as the kernel debugger. So _every_ color of
> the spectrum is present: immediate integration, immediate rejection,
> long-term integration, long-term rejection, ping-pong of rejections
> until integration, and even decisions that seem to take a near
> 'eternity' in very rare cases.
>
> If a biologist took a look at these gene pool dynamic parameters alone,
> without knowing a squat about kernel technology, the likely conclusion
> would be that this is "a healthy, diverse gene pool that is being
> affected by many many external factors. A true expert at survival, that
> critter!" ;-)
>
> For example, i'm at the moment maintaining in excess of 400 patches "out
> of mainline", many of which will never see the "daylight of upstream".
> Many of those are longer-term "reality checks" that could replace
> in-tree code in the future or are in the process of replacing in-tree
> code as we speak. Some are "reality checks" that _failed_ to replace
> in-tree code but i'm still maintaining them because i find them useful.
> If the kernel code that these patches modify happens to be modularized
> then it is sometimes helpful to my out-of-tree patches (and sometimes
> it's a pain) - but in any case, i dont "require" nor "suggest" upstream
> maintainers to modularize, just to make my "out of tree" life easier.
> Are they still useful to Linux in general? I sure hope so.
>
> It was always like this in Linux: modularization is mainly dictated by
> the needs of the in-tree code - and that's very much on purpose, and
> always was, to increase the advantages of including good external genes
> in the kernel gene pool.

<permission to jump down my throat granted now>

Nope. I can't equate your soliloquy about the development process with
what it appears you are doing in the case of plugsched but you're
obviously too smart for me to argue against or I don't understand and
I've already overstepped my authority on this mailing list being an
ordinary user.  I'll just end up trying to extract your boot from my
anus.
