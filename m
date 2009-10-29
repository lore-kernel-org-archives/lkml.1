Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbZJ2IEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbZJ2IEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZJ2IE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:04:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46734 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbZJ2IEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:04:22 -0400
Date: Thu, 29 Oct 2009 09:04:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] tracefs
Message-ID: <20091029080410.GA26970@elte.hu>
References: <20091023004937.GA24035@kroah.com> <20091023053237.GA24359@elte.hu> <20091028010647.GB14956@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028010647.GB14956@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Fri, Oct 23, 2009 at 07:32:37AM +0200, Ingo Molnar wrote:
> > 
> > * Greg KH <greg@kroah.com> wrote:
> > 
> > > Hi all,
> > > 
> > > At LinuxCon this year, Steven and I talked about moving the 
> > > debugfs usage in the tracing core to a stand-alone filesystem to 
> > > give the ability to start to lock down the api so that people an 
> > > count on what is going on in the tracing userspace interface.
> > 
> > What we want to move out initially (and i talked to Steve and 
> > Frederic about that a few weeks ago) is the event description bits - 
> > the format stuff in /debug/tracing/events/ - but definitely not all 
> > the other, rather messy and ad-hoc APIs.
> > 
> > _No way_ do we want to tie down the pretty-printing ftrace details 
> > as an ABI. We promised that when ftrace went upstream and all the 
> > details are way too messy to be exposed in an ABI alike matter (and 
> > yes, consider this a NAK Steve ;-).
> 
> Ok, I'll drop this.  There was some cleanups I found, I'll pick those 
> out and send them on.  What tree should I base off of to send cleanup 
> patches to?

The tip of the tracing tree is in tip:tracing/core, you can find it at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core

Thanks,

	Ingo
