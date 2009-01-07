Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbZAGCRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbZAGCRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759487AbZAGCRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:17:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758052AbZAGCR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:17:28 -0500
Date: Tue, 6 Jan 2009 18:16:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106181647.e22b27d2.akpm@linux-foundation.org>
In-Reply-To: <200901071306.45210.nickpiggin@yahoo.com.au>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
	<20090106151344.0f146286.akpm@linux-foundation.org>
	<200901071306.45210.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 13:06:44 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 07 January 2009 10:13:44 Andrew Morton wrote:
> > (cc added)
> >
> > On Tue, 6 Jan 2009 17:57:44 -0500
> >
> > Christoph Hellwig <hch@infradead.org> wrote:
> > > On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > > > softirq-introduce-statistics-for-softirq.patch
> > > > proc-export-statistics-for-softirq-to-proc.patch
> > > > proc-update-document-for-proc-softirqs-and-proc-stat.patch
> > >
> > > Why is this in procfs?
> >
> > softirq stuff in /proc seems appropriate?  It's alongside
> > /proc/interrupts.  We could put it in /trendy-fs-of-the-day, but what
> > would it gain us?
> 
> Haven't we kind of agreed to use sysfs for things like this? A few years
> too late to be raising objections now ;)
> 
> One problem I have with sysfs is that it (the directory structure, rather
> than the sysfs code itself) really needs to be policed and maintained
> by a central and coherent place/person with taste. Otherwise people put
> their own random crap with their own random naming schemes and becomes
> a crazy mess.
> 
> softirqs are not hardware but purely kernel subsystem construct, as such
> they probably go under /sys/kernel/. People unfortunately have already
> added random crap to the /sys/kernel/ root directory, but future additions
> really should go into a good subdirectory structure (putting it into the
> root directory is equivalent to ditching all subdirectories from /proc/sys/).

All sounds like pointless wank^Wbikeshed painting to me.

> /sys/kernel/softirq/*, I suggest.

What would that *improve*?

