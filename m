Return-Path: <linux-kernel-owner+w=401wt.eu-S1031123AbXD1WMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031123AbXD1WMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031116AbXD1WMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:12:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:48819 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030905AbXD1WMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:12:03 -0400
From: Neil Brown <neilb@suse.de>
To: "Martin J. Bligh" <mbligh@mbligh.org>
Date: Sun, 29 Apr 2007 08:11:30 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17971.50834.907414.761549@notabene.brown>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Linux 2.6.21
In-Reply-To: message from Martin J. Bligh on Saturday April 28
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	<20070426040806.GJ3468@stusta.de>
	<20070426125802.GL3468@stusta.de>
	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	<4630DB24.4030005@redhat.com>
	<20070426201325.8a1ebda3.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
	<20070426224148.69b91b2e.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
	<46339BC7.6050802@mbligh.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday April 28, mbligh@mbligh.org wrote:
> 
> Yes, human involvement from someone with half a brain would be better.
> Andrew does a lot of that. Not a particularly good use of talent really.
> but still.

I think more than half a brain is needed to do this well.  You need a
reasonable understanding of how all the bits of the kernel work
together so that you have a good chance of sending the bug in the right
direction.  You need a good understanding of the kernel community and
various sub communities so that you know who might be both able and
willing to deal with the bug.  And it wouldn't hurt to have a good
over-view of the current 'hot' areas of the kernel so you know if it
is really worth suggesting "try with the latest -mm" or not.
And you need good people skills.

So I think you really need a lot of up-to-date knowledge to do this
well.  Because of Andrew's position as a funnel, he has a lot of that
knowledge.  It would be really nice if he had some help though.  And I
really think that would mean finding someone in the community who
would rather be coding (and currently are) and convincing them that
there is a higher calling for them.  Finding someone out side or on
the edge of the community is less likely to be effective.

> 
> As Andrew has pointed out before though - even though he forwards
> the bugs, nobody does anything with it. The sad truth seems to be
> that people have very little interest in fixing bugs when they are
> reported - it's not sexy, I guess.

Not sexy, and also not at all easy.   A lot of the interesting bugs
seem to be subtle interactions between separate parts of the kernel -
one part making an assumption or exhibiting a behaviour that the other
part didn't expect.  And we all know that writing bug^Wcode is easier
than removing bugs.  I can spend hour and hours reading through code
trying to get the big picture, and end up finding a one-line change
that then needs documenting, testing and external review.  It's not
easy.

> I'm still unconvinced the users or the tool are the problem, but if it
> makes you happier, we can do that.

No, they aren't the problem.  Bugs are the problem.  But they might be
a more effective part of the solution.

My perception of the kernel bugzilla is that visibility is very low.

I think there is value in weekly reminders, and I wouldn't mind seeing
a weekly Email on linux-kernel with something like a list of open bugs
that have not seen any activity in between 1 and 2 weeks.  It might
get someone out-of-area interested, and might be noticed by someone
who thinks they are in-area and get them wondering why they didn't
find out when the bug was first reported.

NeilBrown
