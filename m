Return-Path: <linux-kernel-owner+w=401wt.eu-S934271AbZJMUOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbZJMUOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760498AbZJMUOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:14:33 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:45013 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753802AbZJMUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:14:33 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Announce: Sysprof 1.1.2 CPU profiler for Linux
References: <ye8bpkxemk0.fsf@camel21.daimi.au.dk>
	<20091006150751.GA28868@infradead.org>
	<20091012205812.GF17163@elte.hu>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 13 Oct 2009 22:13:54 +0200
In-Reply-To: <20091012205812.GF17163@elte.hu>
Message-ID: <ye8pr8r59x9.fsf@camel23.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.142
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Sat, Sep 26, 2009 at 05:46:23PM +0200, Soeren Sandmann wrote:
> > > Sysprof 1.1.2 is now available. This is a development release leading
> > > up to a stable 1.2.0 release.
> > > 
> > > Sysprof is a sampling system-wide CPU profiler for Linux.  This
> > > version is based on the perf counter interface in 2.6.31 kernels and
> > > will not work with earlier kernels.
> > 
> > Btw, what is the plan for the sysprof ftrace plugin?  In general we 
> > move away from ftrace plugins towards trace events and perf, and if I 
> > remember correctly ftrace file format changes caused enough pain for 
> > sysprof that it kept shipping it's old hacky kernel module.

Missed this mail somehow. The main issue with the ftrace plugin was
performance. Often, 20% of the time, as reported by sysprof was spent
in the ftrace read() interface. I think some of that came from the
locking code compiled with debug information, but even without that,
there was significant overhead.

The perf counter interface works very well and will eventually allow a
number of new features to be added.

> > Is it time to deprectate the sysprof ftrace plugin?
> 
> Yes - but it's minimal maintenance overhead so we want to keep it for 
> kernel release or two, to sunset it properly.

Makes sense to me.



Thanks,
Soren

