Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0BVK2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:28:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0BVK2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:28:04 -0500
Date: Mon, 22 Feb 2010 11:27:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, linux-tip-commits@vger.kernel.org
Subject: Re: linux-next requiements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
Message-ID: <20100222102745.GJ20844@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
 <20100222090710.GA31357@elte.hu>
 <20100222203319.8bd497a2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222203319.8bd497a2.sfr@canb.auug.org.au>
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

> Hi Ingo,
> 
> On Mon, 22 Feb 2010 10:07:10 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > I'll keep them in tip:master to get them tested, but note that i cannot 
> > push any of these patches into linux-next until this is fixed, as 
> > linux-next requires all architectures to build, with no regard to which 
> > architectures are tested by kernel testers in practice.
> 
> I merely expect people not to push known broken code into linux-next.

FYI, this 'mere' kind of indiscriminate definition of 'breakage' is what i am 
talking about.

The occasional driver build breakage can be tested relatively easily: one 
allyesconfig build and it's done. Build testing 22 architectures is 
exponentially harder: it requires the setup (and constant maintenance) of 
zillions of tool-chains, plus the build time is significant as well.

So this kind of linux-next requirement causes the over-testing of code that 
doesnt get all that much active usage, plus it increases build testing 
overhead 10-fold. That, by definition, causes the under-testing of code that 
_does_ matter a whole lot more to active testers of the Linux kernel.

Which is a problem, obviously.

	Ingo
