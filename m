Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968167Ab0B0MWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:22:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54170 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966869Ab0B0MWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:22:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next requirements
Date: Sat, 27 Feb 2010 13:23:14 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rjw; KDE/4.3.5; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
References: <20100211195614.886724710@sbs-t61.sc.intel.com> <20100224182540.918b48b0.sfr@canb.auug.org.au> <20100227093948.GB31794@elte.hu>
In-Reply-To: <20100227093948.GB31794@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002271323.14402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 February 2010, Ingo Molnar wrote:
> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > [I have removed linux-tip-commits from the cc list]
> > 
> > Hi Ingo,
> > 
> > On Tue, 23 Feb 2010 09:45:52 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > Developers simply cannot be expected to build for 22 architectures, and 
> > > they shouldnt be.
> > 
> > I have agreed with this point of yours several times.  Why do you keep 
> > stating it?
> 
> If you agree with me then why do you put so much focus on cross-arch build 
> failures, versus other, more relevant forms of testing?

I don't really know what this is all about.  Stephen does what he can and
that's generally appreciated very much.  It helps to make sure the code builds
correctly on the architectures it's supposed to build on and there's nothing
wrong with that IMO.

> > > The thing is, last i checked you didnt even _test_ x86 as the first step 
> > > in your linux-next build tests. Most of your generic build bug reports are 
> > > against PowerPC. They create the appearance that x86 is a second class 
> > > citizen in linux-next.
> > 
> > Lets see.  Over the last 60 days, I have reported 37 build errors.  Of 
> > these, 16 were reported against x86, 14 against ppc, 7 against other archs.
> 
> So only 43% of them were even relevant on the platform that 95+% of the Linux 
> testers use? Seems to support the points i made.

Well, I hope you don't mean that because the majority of bug reporters (vs
testers, the number of whom is unknown to me at least) use x86, we are free
to break the other architectures. ;-)

> > Of the ppc reports, 10 would not affect x86 builds (due to being ppc 
> > specific problems or dependencies on implicit includes that do happen on 
> > x86).  None of the reports against other arches would affect x86 builds.
> > 
> > I also reported 31 warnings.  15 against x86, 15 against ppc and 1 against 
> > both.  Of those only reported against ppc, 13 did not affect x86.
> > 
> > So of my "generic" reports, 4 errors and 2 warnings were reported against 
> > ppc, 16 errors and 15 warnings again x86.
> > 
> > Also, I am not sure how reports of 37 build errors and 32 warnings over 60 
> > days can tax the resources of our developer base. [...]
> 
> Note that out of those 37 build errors only a small minority were caused by 
> any tree i co-maintain. (i dont have the precise numbers but it's below 5)
> 
> Why? Because i cross-build before pushing to linux-next. I bug people about 
> cross-arch build failures, and about the patch flow delays and hickups this 
> causes. Without that you'd see twice that many cross-build failures.
> 
> Which in itself is not bad of course (any fix is a good fix) - except the 
> forced prioritization and its place in the workflow: it sends the wrong 
> testing message.
> 
> It sends the message that building on N architectures is more important than 
> for the code to work for real people. I've had good developers waste their 
> time trying to set up cross-build testing environments and complain to me how 
> this complicates their testing.

That's the kind of task linux-next is really good at AFAICT.  Before linux-next
I used to have a cross-build testing environment like this, but I don't need it
any more, because I know linux-next will catch the cross-build problems for
me and I appreciate that very much, because it saves a lot of my time.

Rafael
