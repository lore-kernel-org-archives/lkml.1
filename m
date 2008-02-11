Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYBKUzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYBKUzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYBKUzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:55:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37417 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750852AbYBKUzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:55:47 -0500
Date: Mon, 11 Feb 2008 14:55:43 -0600
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] mempolicy: support optional mode flags
Message-Id: <20080211145543.8821960c.pj@sgi.com>
In-Reply-To: <1202747811.5014.37.camel@localhost>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<1202747811.5014.37.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> We need to sort out with Andrew, Mel, Paul, ... the order in which these
> interdependent changes go in.  Given such an order, I'm willing to merge
> them all up, test them, and post them [after running checkpatch, of
> course].

These patches look like good stuff at first glance.   Thanks, David.

If things go as I hope, I expect to spend a couple of days this week
reviving my earlier patch RFC that a couple of you on this cc list saw,
concerning how nodes are numbered in mempolicy nodemasks.  Certainly
the work being done in these various recent patches will affect my
patch ... it's in the same code.

David or Lee -- could you recommend to me which of these various patches
of late I should apply first in my workarea, in what order, before I
add my patch?  After fixing up conflicts between my earlier patch and
these good patches of yours, I'll try to do some testing of the code
paths that my patch most likely affected, to ensure that I don't break
any existing code.  I'll also probably have some more detailed review
comments on these patches, as I work through them and resolve conflicts
between them and my patch.

For lurkers who are wondering just what my earlier RFC patch will did,
I'm avoiding explaining that here.  It will take a bit of careful
explanation, or else things get rather confused.  My goal is to propose
my nodemask numbering patch by the end of this week, as an RFC,
publicly and clearly presented, and built and tested (somewhat) on top
of these other patches.  My nodemask numbering patch is more of a new
feature than a code cleanup, so probably should end up going in after
these other patches.

Then if Lee can add his testing, and after Lee and/or David post
these patches, they can either push mine too, or I can follow up with
a final PATCH that I recommend for *-mm, based on feedback from my
RFC of this week, that applies on top of this good work.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
