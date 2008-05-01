Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbYEAAPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbYEAAPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYEAAPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:15:04 -0400
Received: from eastrmmtao107.cox.net ([68.230.240.59]:55929 "EHLO
	eastrmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYEAAPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:15:03 -0400
Date: Wed, 30 Apr 2008 20:15:00 -0400
From: Chris Shoemaker <c.shoemaker@cox.net>
To: Willy Tarreau <w@1wt.eu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501001500.GC1559@pe.Belkin>
References: <20080430135405.ddc42075.akpm@linux-foundation.org> <20080430221936.GA27292@elte.hu> <20080430.152227.23100100.davem@davemloft.net> <200805010039.02451.rjw@sisk.pl> <20080430231221.GP8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430231221.GP8474@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 01:12:21AM +0200, Willy Tarreau wrote:
> On Thu, May 01, 2008 at 12:39:01AM +0200, Rafael J. Wysocki wrote:
> > In fact, so many changes go in at a time during a merge window, that we often
> > can't really say which of them causes the breakage observed by testers and
> > bisection, that IMO should really be a last-resort tool, is used on the main
> > debugging techinque.
> 
> Maybe we could slightly improve the process by releasing more often, but
> based on topics. Small sets of minimally-overlapping topics would get
> merged in each release, and other topics would only be allowed to pull
> fixes. That way everybody still gets some work merged, everybody tests
> and problems are more easily spotted.
> 
> I know this is in part what Andrew tries to do when proposing to
> integrate trees, but maybe some approximate rules should be proposed
> in order for developers to organize their works. This would begin
> with announcing topics to be considered for next branch very early.
> This would also make it more natural for developers to have creation
> and bug-tracking phases.

What would this look like, notionally?  Say the releases were twice as
frequent with Stage A and Stage B.  How could the topic be grouped
into the stages?  Could bugfixes of any type be merged in either
window?  Would this only apply to "new" features, API changes, etc? or
would maintenance-type changes have to be assigned to a stage, too?

-chris
