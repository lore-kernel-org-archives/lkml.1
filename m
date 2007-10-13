Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbXJMAMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbXJMAMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbXJMAMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:12:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXJMAMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:12:09 -0400
Date: Fri, 12 Oct 2007 20:11:53 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: arch merge fallout.
Message-ID: <20071013001153.GA30688@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20071012035743.GA12897@redhat.com> <alpine.LFD.0.999.0710112103240.6887@woody.linux-foundation.org> <20071012182504.GA9222@redhat.com> <alpine.LFD.0.999.0710121457230.6887@woody.linux-foundation.org> <20071012221253.GB4290@redhat.com> <alpine.LFD.0.999.0710121542030.6887@woody.linux-foundation.org> <20071012225222.GD4290@redhat.com> <alpine.LFD.0.999.0710121608460.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710121608460.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 04:14:54PM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Fri, 12 Oct 2007, Dave Jones wrote:
 > >
 > > Something I find useful is to just do for eg..
 > > 
 > > git log arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
 > > 
 > > from time to time, to figure out when certain changes happened,
 > > or even to grep for something in a changelog.
 > > With that file moved, git refuses to tell me about the log
 > > of a file that doesn't exist, and the log of the moved
 > > file in arch/x86 just has a single commit, detailing the move.
 > > 
 > > Is there an easy way to get the complete log of a file?
 > 
 > The "--follow" flag will follow renames when doing a log, so a simple
 > 
 > 	git log --follow arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
 > 
 > will do it.

Hrmm.

$ git log --follow arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
fatal: ambiguous argument 'arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c':
unknown revision or path not in the working tree.
Use '--' to separate paths from revisions

Using --follow on the arch/x86 post-merge file gives me even less info
than it does without it :)

 > [ Although I actually introduced a bug in that last week, so if it gives 
 >   empty output for you, add a "--stat" to get a diffstat (or "-p" to get 
 >   the whole patch) to work around a stupid mistake. That bug is in both 
 >   1.5.3.3 and 1.5.3.4 - and Junio happens to be away for two weeks, so 
 >   it's not fixed in any release yet. I have a trivial patch for it if you 
 >   care, but the "use -p" workaround is usually what you want to do anyway, 
 >   which is probably why  nobody even noticed it was broken! ]

Is what I'm seeing above indicative of this bug ? Or something else?  
Adding -p or --stat makes no difference at all.

	Dave

-- 
http://www.codemonkey.org.uk
