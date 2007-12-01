Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXLAQbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXLAQbx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 11:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbXLAQbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 11:31:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53043 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXLAQbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 11:31:37 -0500
Date: Sat, 1 Dec 2007 08:30:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       abelay@novell.com, lenb@kernel.org, mlord@pobox.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Message-ID: <20071201083002.7d104399@laptopd505.fenrus.org>
In-Reply-To: <20071201021740.2e66b918.akpm@linux-foundation.org>
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>
	<20071130142058.816d1693.akpm@linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
	<4750CC78.9070105@rtr.ca>
	<20071130190227.1976e682@laptopd505.fenrus.org>
	<4750D180.6080001@rtr.ca>
	<20071201021740.2e66b918.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 02:17:40 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 30 Nov 2007 22:14:08 -0500 Mark Lord <lkml@rtr.ca> wrote:
> 
> > > latency. If your app cant take any latency, you should set
> > > those... and the side effect is that the kernel will not do
> > > long-latency C-states or P-state transitions..
> > ..
> > 
> > I don't mind the cpufreq changing (actually, I want it to drop in
> > cpugfreq to save power and keep the fan off), but the C-states just
> > kill this app.
> 
> semi-OT: I was finding that disabling cpufreq altogether on the Vaio
> speeds up `quilt push 1000' by a lot - around 30% iirc.

I assume this is using the ondemand governor and not userspace?
(some older distros mistakingly used "userspace" and yes, that will
suck)

# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 
ondemand

(to make it easily cut-n-pastable to check)

> 
> There do seem to be some unsophisticated decisions in there and we're
> losing quite a bit of performance as a result.

if you can give a simple recipe for one of these, we can add it to our
workload testsuite that at least some of us use every time we change
either the C states or the cpufreq stuff....

(and yes we want to improve things)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
