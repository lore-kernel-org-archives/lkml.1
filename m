Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbZJWTfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbZJWTfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 15:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZJWTfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 15:35:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbZJWTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 15:35:09 -0400
Subject: [RFC] to rebase or not to rebase on liunx-next
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
       "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091023191631.GA1879@elte.hu>
References: <20091020034829.GA12833@elte.hu>
	 <20091020140750.GH11972@erda.amd.com>
	 <alpine.LFD.2.00.0910210654480.5125@eeepc.linux-foundation.org>
	 <20091022122042.e535d43c.sfr@canb.auug.org.au>
	 <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org>
	 <20091023123555.GA25366@elte.hu>
	 <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com>
	 <20091023134115.GD27097@elte.hu>
	 <alpine.LFD.2.00.0910231424440.21460@xanadu.home>
	 <20091023191631.GA1879@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 23 Oct 2009 15:35:12 -0400
Message-Id: <1256326512.26028.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an email attempt to move a thread from users.kernel.org to LKML
where it belongs.

I've tried to Cc all those that were on the original Cc (sorry if you
don't want to be, but just send this to /dev/null in that case).

Here's the basic gist, some people believe that linux-next is used as a
dumping ground for their repos that get rebased all the time. They use
linux-next for early testing, and mostly to make sure their repo will
not collide with other developers repos.

Some of the reasons for the constant rebasing are:

1) the patches are held in quilt, which just by nature leads to
rebasing.  These developers find that quilt is the best tool for the
job.

2) after collisions with other repos, the developers find other ways to
to solve the issue, and rebase it instead of having a bunch of "merged"
conflicts go off to Linus.

3) They want acks and reviewed-by labels added. Which would cause a
rebase because the commit must change to add these.

4) Major bugs are found and bisectablity is broken. Rebasing would keep
the git history working for bisecting.


I'm sure there are other reasons, please feel free to add your own, or
to refute the ones I listed.

Other developers feel that there's too much rebasing going on in
linux-next and that there should be a cleaner work-flow. Perhaps have
maintainers test their work a bit more before passing it off to
linux-next?

This is not a complete description of what is going on, but it gets the
idea across. Now those of you that want to argue this, go ahead. But use
this email as the starting point and keep it off of users.kernel.org

Thanks,

-- Steve


