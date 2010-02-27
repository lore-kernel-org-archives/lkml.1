Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968090Ab0B0Jk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:40:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968061Ab0B0JkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:40:24 -0500
Date: Sat, 27 Feb 2010 10:39:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100227093948.GB31794@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
 <20100222090710.GA31357@elte.hu>
 <20100222203319.8bd497a2.sfr@canb.auug.org.au>
 <20100222102745.GJ20844@elte.hu>
 <20100222224752.0cbd5807.sfr@canb.auug.org.au>
 <20100223084552.GB17617@elte.hu>
 <20100224182540.918b48b0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224182540.918b48b0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> [I have removed linux-tip-commits from the cc list]
> 
> Hi Ingo,
> 
> On Tue, 23 Feb 2010 09:45:52 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Developers simply cannot be expected to build for 22 architectures, and 
> > they shouldnt be.
> 
> I have agreed with this point of yours several times.  Why do you keep 
> stating it?

If you agree with me then why do you put so much focus on cross-arch build 
failures, versus other, more relevant forms of testing?

> > The thing is, last i checked you didnt even _test_ x86 as the first step 
> > in your linux-next build tests. Most of your generic build bug reports are 
> > against PowerPC. They create the appearance that x86 is a second class 
> > citizen in linux-next.
> 
> Lets see.  Over the last 60 days, I have reported 37 build errors.  Of 
> these, 16 were reported against x86, 14 against ppc, 7 against other archs.

So only 43% of them were even relevant on the platform that 95+% of the Linux 
testers use? Seems to support the points i made.

> Of the ppc reports, 10 would not affect x86 builds (due to being ppc 
> specific problems or dependencies on implicit includes that do happen on 
> x86).  None of the reports against other arches would affect x86 builds.
> 
> I also reported 31 warnings.  15 against x86, 15 against ppc and 1 against 
> both.  Of those only reported against ppc, 13 did not affect x86.
> 
> So of my "generic" reports, 4 errors and 2 warnings were reported against 
> ppc, 16 errors and 15 warnings again x86.
> 
> Also, I am not sure how reports of 37 build errors and 32 warnings over 60 
> days can tax the resources of our developer base. [...]

Note that out of those 37 build errors only a small minority were caused by 
any tree i co-maintain. (i dont have the precise numbers but it's below 5)

Why? Because i cross-build before pushing to linux-next. I bug people about 
cross-arch build failures, and about the patch flow delays and hickups this 
causes. Without that you'd see twice that many cross-build failures.

Which in itself is not bad of course (any fix is a good fix) - except the 
forced prioritization and its place in the workflow: it sends the wrong 
testing message.

It sends the message that building on N architectures is more important than 
for the code to work for real people. I've had good developers waste their 
time trying to set up cross-build testing environments and complain to me how 
this complicates their testing.

> [...]  Most of these are fairly trivial to fix (as is shown by how quick 
> they are fixed.  Usually the developer has just forgotten to test the 
> !CONFIG_SOMETHING case or used some function without explicitly including 
> the file that declares it.
> 
> As to my perceived pro-PowerPC and anti-x86 bias, you are the only one who 
> has even mentioned it to me.

Have you asked me recently for example?

> Anyway, I sick of these discussions.  If people see the way I do linux-next 
> as a problem, then they can find someone else.  That is not the impression I 
> gained at the Kernel Summit and (apart from these occasional "discussions") 
> I am quite happy to continue.

Not sure how you jump from my observations to "I will quit if you do this". I 
am simply pointing out problems as i see them - as i do that with every piece 
of the workflow we use. I have expressed my views numerous times about where i 
find linux-next useful and positive - and it's sure a net positive.

	Ingo
