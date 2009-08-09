Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZHINVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZHINVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 09:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZHINVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 09:21:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42540 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbZHINVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 09:21:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Date: Sun, 9 Aug 2009 15:22:02 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
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
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com> <20090806015855.GA20596@sli10-desk.sh.intel.com> <20090809120818.GA1338@ucw.cz>
In-Reply-To: <20090809120818.GA1338@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908091522.02898.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 August 2009, Pavel Machek wrote:
> Hi!
> 
> > > Also, approaches such as [1] can make use of this
> > > extended infrastructure instead of putting the CPU to an arbitrary C-state
> > > when it is offlined, thereby providing the system administrator a rope to hang
> > > himself with should he feel the need to do so.
> > I didn't see the reason why administrator needs to know which state offline cpu
> > should stay. Don't know about powerpc side, but in x86 side, it appears deepest
> > C-state is already preferred.
> > 
> 
> Agreed, deepest c-state is always best, there's no need to make it configurable.

Unless it doesn't work.

Rafael
