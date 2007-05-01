Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbXEAQSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbXEAQSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbXEAQSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:18:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43511 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbXEAQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:18:43 -0400
Date: Tue, 1 May 2007 09:22:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 hangs in boot (netconsole)
Message-Id: <20070501092233.b55d0ea4.randy.dunlap@oracle.com>
In-Reply-To: <20070501062258.GR25929@bingen.suse.de>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070429220132.951cdf7f.randy.dunlap@oracle.com>
	<20070429222354.63265e3f.akpm@linux-foundation.org>
	<20070430081653.60fab0a5.randy.dunlap@oracle.com>
	<20070430165101.6463fee1.randy.dunlap@oracle.com>
	<20070430171229.d514ba19.akpm@linux-foundation.org>
	<46368DC3.5070503@oracle.com>
	<20070430180821.eb269fe3.akpm@linux-foundation.org>
	<20070501034330.GJ25929@bingen.suse.de>
	<20070430221624.dcc7346b.randy.dunlap@oracle.com>
	<20070501062258.GR25929@bingen.suse.de>
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

On Tue, 1 May 2007 08:22:58 +0200 Andi Kleen wrote:

> On Mon, Apr 30, 2007 at 10:16:24PM -0700, Randy Dunlap wrote:
> > On Tue, 1 May 2007 05:43:30 +0200 Andi Kleen wrote:
> > 
> > > > Andi: unprocessor x86_64 running rc7-mm2 is hanging early in boot at
> > > > randomish times (presumably in the timer irq handler) when netconsole and
> > > > printk-time are enabled.
> > > 
> > > A backtrace would be good. Does nmi_watchdog=2 show anything
> > > interesting or if not sysrq-t?
> > 
> > I can't get anything from sysrq or nmi_watchdog.
> 
> Hmm, ok when the console locks up those likely don't work.
> 
> > 
> > > > I was hitting the same thing on i386 uniprocessor, but I thought it got
> > > > fixed.
> > > 
> > > Yes.
> > 
> > Fixed where?  Merged into mainline or in your firstfloor patches?
> 
> None of the sched-clock changes are in mainline yet.
> 
> Can you perhaps test latest firstfloor alone (without rest of -mm)?

OK.  so your 2.6.21-rc7-git5 patch, applied to 2.6.21-git4 or
applied to 2.6.21-rc7-git5 ?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
