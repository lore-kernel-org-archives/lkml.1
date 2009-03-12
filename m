Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZCLKZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZCLKZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZCLKZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:25:16 -0400
Received: from phunq.net ([64.81.85.152]:44336 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754641AbZCLKZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:25:15 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 03:25:09 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903120133.02645.phillips@phunq.net> <20090312094747.GA9309@uranus.ravnborg.org>
In-Reply-To: <20090312094747.GA9309@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120325.09809.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Sam Ravnborg wrote:
> > 
> > > > > - What's "L"?
> > > > > 
> > > > > 		printf("%Lx-", (L)begin);
> > > > 
> > > > A very handy way of working around 32/64 bit format string issues.  We
> > > > just cast all the messy cases to (long long), aka (L).  All other
> > > > solutions to this messy problem are worse in my opinion, but whatever
> > > > the ruling is, is what we will do.  This is used heavily in tracing and
> > > > dumping code, which can all be turned off with ifdefs, so it doesn't
> > > > affect production kernel text.
> > > 
> > > What format string issues are we talking about here?
> > > 
> > > See, a number of them will be fixed real soon now (geologically
> > > speaking) when various 64-bit architectures switch their s64/u64
> > > implementation from `long' to `long long'.
> > 
> > Ah, that would be helpful.  But not done yet?  How long until it
> > happens, and does it make sense to wait, so we can reduce the number
> > of problems cases?  And... will it be all 64 bit arches or just some?
> > Because this issue isn't solved if it isn't fixed for all arches.
> 
> Most if not all will hit mainline during coming merge window.
> When an arch changes u64 becomes unsigned long long.
> 
> It is considered a 'must have' for 64 bit archs these days so
> do not workaround it.

OK, well a mindless edit of (L) to (long long) isn't a workaround, just
a reshuffle.  Then maybe when the 64 bit changes land in a month or two
we can lose most or all of those ugly things.

Regards,

Daniel
