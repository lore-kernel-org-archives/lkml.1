Return-Path: <linux-kernel-owner+w=401wt.eu-S1763114AbXFASoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763114AbXFASoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761787AbXFASoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:44:38 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:59196 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761617AbXFASoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:44:37 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1180714263.15884.52.camel@imap.mvista.com>
References: <20070529125248.877196281@chello.nl>
	 <20070529130107.112347096@chello.nl>
	 <1180470525.32594.71.camel@imap.mvista.com>
	 <20070530132431.GA23947@elte.hu>
	 <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
	 <20070530134907.GA27085@elte.hu>
	 <1180544796.32594.184.camel@imap.mvista.com>
	 <1180545380.2958.1.camel@lappy>
	 <1180545913.32594.194.camel@imap.mvista.com>
	 <20070601131249.GA17059@elte.hu>
	 <1180711606.15884.32.camel@imap.mvista.com> <1180713154.5676.4.camel@lappy>
	 <1180714263.15884.52.camel@imap.mvista.com>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 20:43:40 +0200
Message-Id: <1180723421.5676.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 09:11 -0700, Daniel Walker wrote:
> On Fri, 2007-06-01 at 17:52 +0200, Peter Zijlstra wrote:

> > The whole issue is that you don't have any control over what clocksource
> > you'll end up with. If it so happens that pmtimer gets selected your
> > whole box will crawl if its used liberaly, like the patch under
> > discussion does.
> 
> You can have control over it, which I think the whole point of this
> discussion ..

No you don't, clocksource will gladly discard the TSC when its not found
stable enough (the majority of the systems today). While it would be
good enough for sched_clock().



