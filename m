Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYAQDjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYAQDjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYAQDjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:39:17 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:50746 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbYAQDjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:39:16 -0500
Date: Wed, 16 Jan 2008 22:39:09 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <18318.51622.37470.246611@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.58.0801162234340.21116@gandalf.stny.rr.com>
References: <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
 <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
 <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
 <1200523867.6127.5.camel@localhost.localdomain>
 <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com>
 <1200536889.6127.52.camel@localhost.localdomain> <20080117024000.GD2322@Krystal>
 <20080117025004.GE2322@Krystal> <18318.51622.37470.246611@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Jan 2008, Paul Mackerras wrote:
>
> It's very hard to do a per-thread counter in the VDSO, since threads
> in the same process see the same memory, by definition.  You'd have to
> have an array of counters and have some way for each thread to know
> which entry to read.  Also you'd have to find space for tens or
> hundreds of thousands of counters, since there can be that many
> threads in a process sometimes.

I was thinking about this. What would also work is just the ability to
read the schedule counter for the current cpu. Now this would require that
the task had a way to know which CPU it was currently on.

-- Steve

