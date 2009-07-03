Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbZGCHYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbZGCHYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZGCHYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:24:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59073 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZGCHYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:24:09 -0400
Date: Fri, 3 Jul 2009 09:24:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
	kernel modules
Message-ID: <20090703072400.GA7943@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net> <20090702064712.GA26690@elte.hu> <1246519076.6384.22.camel@marge.simson.net> <1246536617.4752.15.camel@laptop> <1246605459.6092.189.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246605459.6092.189.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Thu, 2009-07-02 at 14:10 +0200, Peter Zijlstra wrote:
> > On Thu, 2009-07-02 at 09:17 +0200, Mike Galbraith wrote:
> > 
> > >  I've been pondering a perf archive tool
> > > that would package everything that's needed to do analysis on a
> > > different box.  One big problem though, is that while you can easily
> > > package vmlinux and modules, what about all the userland binaries?  A
> > > large perf.data and/or debug info binaries can easily make transport
> > > impractical enough.
> > 
> > I would simply extend the current file header with another section in
> > which we do a structured storage of the data structures we currently
> > build in perf-report. That is, the dso and symbol bits.
> > 
> > If we then run perf-report on a file containing such a section we read
> > that data instead of trying to locate them the regular way.
> 
> That's a good idea.
> 
> If uname doesn't match stored record time uname, you're not live, 
> so tools require an exportable perf.data.  If you're not live and 
> not on the same host, annotate requires binaries appended via an 
> export tool with --sym-filter -k -u -% whatever capability.

'perf export' could be a nice shortcut to convert a local perf.data 
into a off-line analysable body of data.

	Ingo
