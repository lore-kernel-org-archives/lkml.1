Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZCLJqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZCLJqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZCLJpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:45:52 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:48135 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbZCLJpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:45:51 -0400
Date: Thu, 12 Mar 2009 10:47:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-ID: <20090312094747.GA9309@uranus.ravnborg.org>
References: <200903110925.37614.phillips@phunq.net> <200903112238.55864.phillips@phunq.net> <20090311230713.d4710050.akpm@linux-foundation.org> <200903120133.02645.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903120133.02645.phillips@phunq.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > > - What's "L"?
> > > > 
> > > > 		printf("%Lx-", (L)begin);
> > > 
> > > A very handy way of working around 32/64 bit format string issues.  We
> > > just cast all the messy cases to (long long), aka (L).  All other
> > > solutions to this messy problem are worse in my opinion, but whatever
> > > the ruling is, is what we will do.  This is used heavily in tracing and
> > > dumping code, which can all be turned off with ifdefs, so it doesn't
> > > affect production kernel text.
> > 
> > What format string issues are we talking about here?
> > 
> > See, a number of them will be fixed real soon now (geologically
> > speaking) when various 64-bit architectures switch their s64/u64
> > implementation from `long' to `long long'.
> 
> Ah, that would be helpful.  But not done yet?  How long until it
> happens, and does it make sense to wait, so we can reduce the number
> of problems cases?  And... will it be all 64 bit arches or just some?
> Because this issue isn't solved if it isn't fixed for all arches.

Most if not all will hit mainline during coming merge window.
When an arch changes u64 becomes unsigned long long.

It is considered a 'must have' for 64 bit archs these days so
do not workaround it.

	Sam
