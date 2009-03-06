Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZCFKUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZCFKUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZCFKT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:19:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54214 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbZCFKT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:19:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/4] Rework disabling of interrupts during suspend-resume
Date: Fri, 6 Mar 2009 11:19:29 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200902221837.49396.rjw@sisk.pl> <200903012321.40328.rjw@sisk.pl> <alpine.LFD.2.00.0903051542270.19207@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903051542270.19207@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061119.33023.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009, Linus Torvalds wrote:
> 
> On Sun, 1 Mar 2009, Rafael J. Wysocki wrote:
> > 
> > The following patches modifiy the way in which we handle disabling interrupts
> > during suspend and enabling them during resume.  They also change the ordering
> > of the core suspend and hibernation code.
> 
> Side note - I've tested them on the EeePC that had trouble resuming due to 
> interrupt timings, and it suspends and resumes fine with these patches 
> (modulo some new X problems, but that's what I get for living with 
> Fedora-11 testing).
> 
> Of course, it also suspends and resumes without them, since the CPU "cli" 
> was sufficient for that machine, and it doesn't have any ACPI issues. But 
> it's still an ack that at least nothing breaks that I can tell.

OK, thanks for testing!  The next-step patches (ie. PCI suspend-resume rework)
are in the works.

Rafael
