Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbYCDXBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbYCDXBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765930AbYCDXBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:01:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54541 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765405AbYCDXBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:01:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Date: Wed, 5 Mar 2008 00:00:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Lukas Hejtmanek <xhejtman@ics.muni.cz>
References: <200803030316.07165.rjw@sisk.pl> <20080304111715.GB23227@elf.ucw.cz> <20080304135932.GF32383@elte.hu>
In-Reply-To: <20080304135932.GF32383@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803050000.27897.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of March 2008, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10012
> > > Subject		: 2.6.24-git4+ regression
> > 
> > Better  description would be "interactivity problems in -git4+".
> > 
> > > Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> > > Date		: 2008-01-30 14:56
> > > References	: http://lkml.org/lkml/2008/1/30/254
> > > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > > 		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > 
> > And he has GROUP_SCHED enabled, that is known broken. 
> 
> this should all be fixed in sched-devel.git (via a revert):
> 
>   http://people.redhat.com/mingo/sched-devel.git/README
> 
> it's lined up for upstream pull.

Is it:

commit 62fb185130e4d420f71a30ff59d8b16b74ef5d2b
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Feb 25 17:34:02 2008 +0100

    sched: revert load_balance_monitor() changes

