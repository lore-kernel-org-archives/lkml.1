Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbXJLXLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbXJLXLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934018AbXJLWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:44:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932519AbXJLWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:44:12 -0400
Date: Fri, 12 Oct 2007 15:43:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: arch merge fallout.
In-Reply-To: <20071012221253.GB4290@redhat.com>
Message-ID: <alpine.LFD.0.999.0710121542030.6887@woody.linux-foundation.org>
References: <20071012035743.GA12897@redhat.com>
 <alpine.LFD.0.999.0710112103240.6887@woody.linux-foundation.org>
 <20071012182504.GA9222@redhat.com> <alpine.LFD.0.999.0710121457230.6887@woody.linux-foundation.org>
 <20071012221253.GB4290@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Oct 2007, Dave Jones wrote:
> 
> pull req below.  If it turns out to be more trouble than its worth,

It merged totally automatically, no trouble what-so-ever:

	Renamed arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c => arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
	Auto-merged arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
	Renamed arch/i386/kernel/cpu/cpufreq/longhaul.c => arch/x86/kernel/cpu/cpufreq/longhaul.c
	Auto-merged arch/x86/kernel/cpu/cpufreq/longhaul.c
	Auto-merged arch/powerpc/platforms/cell/cbe_cpufreq.c
	Merge made by recursive.

I think it was just unlucky that the particular version of git you have 
probably hit exactly in the window of "limited rename detection" *and* 
lacking the config switch to turn off the limiter.

		Linus
