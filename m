Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbYAJSFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbYAJSFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbYAJSFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:05:06 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:43242 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830AbYAJSFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:05:03 -0500
Date: Thu, 10 Jan 2008 13:03:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>, Adam Belay <abelay@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <ak@suse.de>
Subject: RE: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5A2710@orsmsx423.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.58.0801101301300.15391@gandalf.stny.rr.com>
References: <1199759244.26343.35.camel@localhost.localdomain>
 <20080108033329.GI2998@bingen.suse.de> <1199911330.975.3.camel@localhost.localdomain>
 <1199916725.975.6.camel@localhost.localdomain> <20080110134539.GD5886@elte.hu>
 <Pine.LNX.4.58.0801100936320.6420@gandalf.stny.rr.com>
 <924EFEDD5F540B4284297C4DC59F3DEE5A2710@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 10 Jan 2008, Pallipadi, Venkatesh wrote:
>
>
> With 2.6.23, you can try compiling acpi processor.ko as a module and
> doing insmod and rmmod in a loop. That should call cpu_idle_wait very
> frequently.

The thing is, after the full boot, there's too many things going on to
keep a system fully idle. Little services can wake a processor up. The
problem I had was that this happens on early bootup where there's not much
around to wake the sleeping processor.

I'm not sure if it is too much of a problem after boot up.

-- Steve

