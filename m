Return-Path: <linux-kernel-owner+w=401wt.eu-S934293AbYBGVYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293AbYBGVYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935378AbYBGVVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:21:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbYBGVVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:21:00 -0500
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper
	(bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <200802072053.21131.rjw@sisk.pl>
References: <200802010237.59320.rjw@sisk.pl>
	 <200802070031.03955.rjw@sisk.pl> <20080206233434.GA12393@elte.hu>
	 <200802072053.21131.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 22:20:33 +0100
Message-Id: <1202419233.6274.47.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 20:53 +0100, Rafael J. Wysocki wrote:
> On Thursday, 7 of February 2008, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > > http://programming.kicks-ass.net/kernel-patches/sched-rt-group/
> > > > 
> > > > on top of sched-devel.
> > > 
> > > Indeed, with these patches applied the issue is not reproducible any 
> > > more.
> > 
> > great! I've queued Peter's fixes and enhancements up in sched-devel. 
> > (not pushed out yet)
> 
> However, these patches break my second testbed (dual -core AMD desktop),
> with the attached config.
> 
> It crashes on boot with the following trace:

Ah, that is the last patch - which I didn't intent to push out. Let me
remove that - its me fighting the group scheduling latencies reported.

Its not lined up for merging.

