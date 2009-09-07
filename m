Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZIGH6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZIGH6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZIGH6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:58:48 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:11342 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZIGH6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:58:48 -0400
X-SourceIP: 213.93.53.227
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Ani <asinha@zeugmasystems.com>,
       Lucas De Marchi <lucas.de.marchi@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1252218779.6126.17.camel@marge.simson.net>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 09:59:34 +0200
Message-Id: <1252310374.7564.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 08:32 +0200, Mike Galbraith wrote:
> On Sat, 2009-09-05 at 19:32 -0700, Ani wrote: 
> > On Sep 5, 3:50 pm, Lucas De Marchi <lucas.de.mar...@gmail.com> wrote:
> > >
> > > Indeed. I've tested this same test program in a single core machine and it
> > > produces the expected behavior:
> > >
> > > rt_runtime_us / rt_period_us     % loops executed in SCHED_OTHER
> > > 95%                              4.48%
> > > 60%                              54.84%
> > > 50%                              86.03%
> > > 40%                              OTHER completed first
> > >
> > 
> > Hmm. This does seem to indicate that there is some kind of
> > relationship with SMP. So I wonder whether there is a way to turn this
> > 'RT bandwidth accumulation' heuristic off.
> 
> No there isn't..

Actually there is, use cpusets to carve the system into partitions.

