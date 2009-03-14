Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZCNSCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZCNSCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 14:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZCNSCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 14:02:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:53032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbZCNSCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 14:02:35 -0400
Subject: Re: [git-pull -tip] x86: cleanup patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090314170355.GE31930@elte.hu>
References: <1237047188.4546.31.camel@ht.satnam>
	 <20090314170355.GE31930@elte.hu>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 23:32:00 +0530
Message-Id: <1237053720.3144.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 18:03 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > The following changes since commit 4cca0345b9c1ee3573bcd0ea5feb3b44caa7930c:
> >   Ingo Molnar (1):
> >         Merge branch 'tracing/ftrace'
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
> > 
> > Jaswinder Singh Rajput (9):
> >       x86: cpu/intel.c cleanup
> >       x86: i8237.c cleanup
> >       x86: topology.c cleanup
> >       x86: kdebugfs.c cleanup
> >       x86: i8253 cleanup
> >       x86: pci-nommu.c cleanup
> >       x86: io_delay.c cleanup
> >       x86: rtc.c cleanup
> >       x86: trampoline.c cleanup
> > 
> >  arch/x86/kernel/cpu/intel.c  |  186 +++++++++++++++++++++---------------------
> >  arch/x86/kernel/i8237.c      |    5 +-
> >  arch/x86/kernel/i8253.c      |   25 +++---
> >  arch/x86/kernel/io_delay.c   |    6 +-
> >  arch/x86/kernel/kdebugfs.c   |   35 +++++---
> >  arch/x86/kernel/pci-nommu.c  |   29 ++++--
> >  arch/x86/kernel/rtc.c        |   22 +++--
> >  arch/x86/kernel/topology.c   |   10 ++-
> >  arch/x86/kernel/trampoline.c |    3 +-
> >  9 files changed, 175 insertions(+), 146 deletions(-)
> 
> Hm, most of these files need deeper cleanups than just surface 
> polishing. Are you willing to do those cleanups if someone goes 
> through those files and comes up with a few suggestions?
> 

OK.

> Which reminds me, i suggested a few structural and code flow 
> cleanups wrt. smp_read_mpc() in the past and those didnt seem to 
> have happened either. See the attached mail below - most of the 
> code flow suggetions i made in it went unaddressed AFAICS.
> 

I have almost completed what you suggested me only few things was left
and as I remembered I also prepared the final patches but I do not have
any multiple processor machines to test it, and then I was busy in
another threads like headers-check, perf-counters, cpu_debug.

I will again search those patches and send to you for final testing.

Thanks for reminding :-)

--
JSR

