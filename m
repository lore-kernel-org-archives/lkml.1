Return-Path: <linux-kernel-owner+w=401wt.eu-S2992879AbXCCBmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992879AbXCCBmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992895AbXCCBmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:42:52 -0500
Received: from holomorphy.com ([66.93.40.71]:43637 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992879AbXCCBmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:42:51 -0500
Date: Fri, 2 Mar 2007 17:40:04 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Bill Irwin <bill.irwin@oracle.com>,
       Christoph Lameter <clameter@engr.sgi.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070303014004.GC23573@holomorphy.com>
References: <20070302100619.cec06d6a.akpm@linux-foundation.org> <Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com> <45E86BA0.50508@redhat.com> <20070302211207.GJ10643@holomorphy.com> <45E894D7.2040309@redhat.com> <20070302135243.ada51084.akpm@linux-foundation.org> <45E89F1E.8020803@redhat.com> <20070302142256.0127f5ac.akpm@linux-foundation.org> <45E8A677.7000205@redhat.com> <20070302145906.653d3b82.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302145906.653d3b82.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 02:59:06PM -0800, Andrew Morton wrote:
> What is it with vendors finding MM problems and either not fixing them or
> kludging around them and not telling the upstream maintainers about *any*
> of it?

I'm not in the business of defending vendors, but a lot of times the
base is so far downrev it's difficult to relate it to much of anything
current. It may be best not to say precisely how far downrev things can
get, since some of these things are so old even distro vendors won't
touch them.


On Fri, Mar 02, 2007 at 02:59:06PM -0800, Andrew Morton wrote:
> Somehow I don't believe that a person or organisation which is incapable of
> preparing even a simple testcase will be capable of fixing problems such as
> this without breaking things.

My gut feeling is to agree, but I get nagging doubts when I try to
think of how to boil things like [major benchmarks whose names are
trademarked/copyrighted/etc. censored] down to simple testcases. Some
other things are obvious but require vast resources, like zillions of
disks fooling throttling/etc. heuristics of ancient downrev kernels.
I guess for those sorts of things the voodoo incantations, chicken
blood, and carcasses of freshly slaughtered goats come out. Might as
well throw in a Tarot reading and some tea leaves while I'm at it.

My tack on basic stability was usually testbooting on several arches,
which various people have an active disinterest in (suggesting, for
example, that I throw out all of my sparc32 systems and replace them
with Opterons, or that anything that goes wrong on ia64 is not only
irrelevant but also that neither I nor anyone else should ever fix them;
you know who you are). It's become clear to me that this is insufficient,
and that I'll need to start using some sort of suite of regression tests,
at the very least to save myself the embarrassment of acking a patch that
oopses when exercised, but also to elevate the standard.


-- wli
