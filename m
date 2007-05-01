Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXEACp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXEACp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbXEACp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:45:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbXEACpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:45:55 -0400
Date: Tue, 1 May 2007 05:43:30 +0200
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.21-rc7-mm2 hangs in boot (netconsole)
Message-ID: <20070501034330.GJ25929@bingen.suse.de>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070429220132.951cdf7f.randy.dunlap@oracle.com> <20070429222354.63265e3f.akpm@linux-foundation.org> <20070430081653.60fab0a5.randy.dunlap@oracle.com> <20070430165101.6463fee1.randy.dunlap@oracle.com> <20070430171229.d514ba19.akpm@linux-foundation.org> <46368DC3.5070503@oracle.com> <20070430180821.eb269fe3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430180821.eb269fe3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi: unprocessor x86_64 running rc7-mm2 is hanging early in boot at
> randomish times (presumably in the timer irq handler) when netconsole and
> printk-time are enabled.

A backtrace would be good. Does nmi_watchdog=2 show anything
interesting or if not sysrq-t?

> 
> I was hitting the same thing on i386 uniprocessor, but I thought it got
> fixed.

Yes.

My current sched_clock does not take any locks anymore and it was removed
from the cpufreq handler too.

-Andi
