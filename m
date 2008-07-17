Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYGQIbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYGQIbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYGQIbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:31:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999AbYGQIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:31:13 -0400
Date: Thu, 17 Jul 2008 01:30:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
Message-Id: <20080717013013.e3f7d7cf.akpm@linux-foundation.org>
In-Reply-To: <20080717081121.DEB6015411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
	<20080717003959.edf6531c.akpm@linux-foundation.org>
	<20080717081121.DEB6015411D@magilla.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 01:11:21 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> > It's a strange time to be sending this.
> 
> I've never managed to understand how the timing of your cycles works
> exactly, and I really just work on the "send it when you can" principle.

It's pretty simple - it's just piplining.  During the -rc's we
accumulate stuff for the next release in linux-next and in -mm.  During
the 2.6.x->2.6.x+1-rc1 merge window we transfer that material into
mainline then the cycle starts again.

So new code which turns up during the merge window is a problem.  It
should be reviewed, integrated on top of the already-pending work and
should get some testing in linux-next.  But during the patch-merging
chaos nobody has the time or a suitable tree upon which to be doing
that.

> To be honest all I really know is that stuff is going in now, and that
> I think this stuff of mine is ready to go.

Yes, but all the stuff which is going in now has been reviewed and has
had testing in linux-next and/or -mm.  (In theory).

> > That being said, the impact on existing code is fairly modest and we
> > could perhaps slip it into 2.6.27-rc1.  I haven't looked at it yet.
> 
> I really hope this can be merged in soon (for 2.6.27).  I do think its
> impact is low.  The sooner this goes in, the sooner arch folks can round
> out all their bits and the more time folks like me can spend on actually
> making something new and interesting happen in this area.
> 
> I am happy to do whatever merging/rebasing work helps that happen the
> soonest.  If there is a different GIT tree to branch a rebase from,
> that is easy for me to do.
> 

erk.

Well I got it all merged up relatively easily but I don't know what it
does and I haven't looked at it yet.

It will take some urgent effort from reviewers and, it appears, arch
maintainers to be able to get this over the line.  Even then it wom't
have had any linux-next testing.  This should all have started weeks
ago!

