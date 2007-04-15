Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbXDOXY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbXDOXY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 19:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXDOXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 19:24:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58662 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbXDOXY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 19:24:28 -0400
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Arjan van de Ven <arjan@infradead.org>
To: Ismail =?ISO-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200704160149.42914.ismail@pardus.org.tr>
References: <20070413202100.GA9957@elte.hu>
	 <200704160149.42914.ismail@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Organization: Intel International BV
Date: Sun, 15 Apr 2007 16:23:08 -0700
Message-Id: <1176679389.3945.66.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 01:49 +0300, Ismail Dönmez wrote:
> Hi,
> On Friday 13 April 2007 23:21:00 Ingo Molnar wrote:
> > [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler
> > [CFS]
> >
> > i'm pleased to announce the first release of the "Modular Scheduler Core
> > and Completely Fair Scheduler [CFS]" patchset:
> >
> >    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> 
> Tested this on top of Linus' GIT tree but the system gets very unresponsive 
> during high disk i/o using ext3 as filesystem but even writing a 300mb file 
> to a usb disk (iPod actually) has the same affect.

just to make sure; this exact same workload but with the stock scheduler
does not have this effect?

if so, then it could well be that the scheduler is too fair for it's own
good (being really fair inevitably ends up not batching as much as one
should, and batching is needed to get any kind of decent performance out
of disks nowadays)


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

