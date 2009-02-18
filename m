Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZBRWYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZBRWYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZBRWYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:24:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59043 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZBRWYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:24:07 -0500
Date: Wed, 18 Feb 2009 17:23:16 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, compudj@krystal.dyndns.org
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090218222316.GH24507@redhat.com>
References: <20090218195328.GA3112@redhat.com> <1234991725.4799.1.camel@laptop> <20090218213545.GB3112@redhat.com> <1234993580.4799.11.camel@laptop> <20090218220201.GG24507@redhat.com> <1234995035.4799.14.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234995035.4799.14.camel@laptop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Feb 18, 2009 at 11:10:35PM +0100, Peter Zijlstra wrote:
> > > I really am having a difficult time seeing the use in such narrow
> > > tracers.
> > 
> > Part of the problem may come from defining "tracers" as something
> > limited to ftrace engines.  Once such tracepoints are in the kernel,
> > more powerful analytical tools may be attached to them.
> 
> ftrace graph tracer is by far the most powerful thing I've seen [...]

Be that as it may, what you suggested required separate correlation of
data with /proc/interrupts contents.


> What is limiting are these puny little tracers that have no real value.

Which limited resource would even puny tracers exhaust?


> A much better purpose for these tracepoints would be augmenting data in
> existing tracers like the graph/function/sched tracer.

Be more specific.  How would you augment those tracers with e.g.
individual irq numbers, their disposition status (HANDLED etc.).


- FChE
