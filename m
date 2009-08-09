Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZHIMIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZHIMIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 08:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZHIMIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 08:08:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53220 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZHIMIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 08:08:45 -0400
Date: Sun, 9 Aug 2009 14:08:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090809120836.GB1338@ucw.cz>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com> <20090806015855.GA20596@sli10-desk.sh.intel.com> <20090806043351.GC14333@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806043351.GC14333@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Also, approaches such as [1] can make use of this
> > > extended infrastructure instead of putting the CPU to an arbitrary C-state
> > > when it is offlined, thereby providing the system administrator a rope to hang
> > > himself with should he feel the need to do so.
> > I didn't see the reason why administrator needs to know which state offline cpu
> > should stay. Don't know about powerpc side, but in x86 side, it appears deepest
> > C-state is already preferred.
> 
> Yes that is what we would expect, but the deepest sleep state may be
> restricted by BIOS or other system level parameters.  This was the
> main objection to Venki's deepest sleep state for offline cpus
> patch.

'May be restricted'? Kernel already needs to know about that
restriction, just do the right thing...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
