Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbZHJITu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbZHJITu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZHJITu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:19:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36735 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZHJITt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:19:49 -0400
Date: Mon, 10 Aug 2009 10:19:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Shaohua Li <shaohua.li@intel.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090810081941.GA18649@elf.ucw.cz>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com> <20090806015855.GA20596@sli10-desk.sh.intel.com> <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908091522.02898.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-08-09 15:22:02, Rafael J. Wysocki wrote:
> On Sunday 09 August 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > > Also, approaches such as [1] can make use of this
> > > > extended infrastructure instead of putting the CPU to an arbitrary C-state
> > > > when it is offlined, thereby providing the system administrator a rope to hang
> > > > himself with should he feel the need to do so.
> > > I didn't see the reason why administrator needs to know which state offline cpu
> > > should stay. Don't know about powerpc side, but in x86 side, it appears deepest
> > > C-state is already preferred.
> > > 
> > 
> > Agreed, deepest c-state is always best, there's no need to make it configurable.
> 
> Unless it doesn't work.

If it does not work, machine will not boot. We already have
max_cstate= kernel command line option to work around that...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
