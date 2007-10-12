Return-Path: <linux-kernel-owner+w=401wt.eu-S933791AbXJLXMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791AbXJLXMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760718AbXJLWwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:52:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687AbXJLWwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:52:41 -0400
Date: Fri, 12 Oct 2007 18:52:22 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: arch merge fallout.
Message-ID: <20071012225222.GD4290@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20071012035743.GA12897@redhat.com> <alpine.LFD.0.999.0710112103240.6887@woody.linux-foundation.org> <20071012182504.GA9222@redhat.com> <alpine.LFD.0.999.0710121457230.6887@woody.linux-foundation.org> <20071012221253.GB4290@redhat.com> <alpine.LFD.0.999.0710121542030.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710121542030.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 03:43:46PM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Fri, 12 Oct 2007, Dave Jones wrote:
 > > 
 > > pull req below.  If it turns out to be more trouble than its worth,
 > 
 > It merged totally automatically, no trouble what-so-ever:
 > 
 > 	Renamed arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c => arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
 > 	Auto-merged arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
 > 	Renamed arch/i386/kernel/cpu/cpufreq/longhaul.c => arch/x86/kernel/cpu/cpufreq/longhaul.c
 > 	Auto-merged arch/x86/kernel/cpu/cpufreq/longhaul.c
 > 	Auto-merged arch/powerpc/platforms/cell/cbe_cpufreq.c
 > 	Merge made by recursive.
 > 
 > I think it was just unlucky that the particular version of git you have 
 > probably hit exactly in the window of "limited rename detection" *and* 
 > lacking the config switch to turn off the limiter.

Awesome! Thanks for doing that.
One other git quirk that I'm not sure how to work around btw..
Something I find useful is to just do for eg..

git log arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c

from time to time, to figure out when certain changes happened,
or even to grep for something in a changelog.
With that file moved, git refuses to tell me about the log
of a file that doesn't exist, and the log of the moved
file in arch/x86 just has a single commit, detailing the move.

Is there an easy way to get the complete log of a file?

	Dave

-- 
http://www.codemonkey.org.uk
