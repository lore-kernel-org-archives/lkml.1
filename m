Return-Path: <linux-kernel-owner+w=401wt.eu-S1946595AbXEAFNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946595AbXEAFNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946597AbXEAFND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:13:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56868 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946594AbXEAFNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:13:00 -0400
Date: Mon, 30 Apr 2007 22:16:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 hangs in boot (netconsole)
Message-Id: <20070430221624.dcc7346b.randy.dunlap@oracle.com>
In-Reply-To: <20070501034330.GJ25929@bingen.suse.de>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070429220132.951cdf7f.randy.dunlap@oracle.com>
	<20070429222354.63265e3f.akpm@linux-foundation.org>
	<20070430081653.60fab0a5.randy.dunlap@oracle.com>
	<20070430165101.6463fee1.randy.dunlap@oracle.com>
	<20070430171229.d514ba19.akpm@linux-foundation.org>
	<46368DC3.5070503@oracle.com>
	<20070430180821.eb269fe3.akpm@linux-foundation.org>
	<20070501034330.GJ25929@bingen.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 05:43:30 +0200 Andi Kleen wrote:

> > Andi: unprocessor x86_64 running rc7-mm2 is hanging early in boot at
> > randomish times (presumably in the timer irq handler) when netconsole and
> > printk-time are enabled.
> 
> A backtrace would be good. Does nmi_watchdog=2 show anything
> interesting or if not sysrq-t?

I can't get anything from sysrq or nmi_watchdog.

> > I was hitting the same thing on i386 uniprocessor, but I thought it got
> > fixed.
> 
> Yes.

Fixed where?  Merged into mainline or in your firstfloor patches?

> My current sched_clock does not take any locks anymore and it was removed
> from the cpufreq handler too.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
