Return-Path: <linux-kernel-owner+w=401wt.eu-S1031306AbXD2Tkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031306AbXD2Tkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 15:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031294AbXD2Tkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 15:40:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:54656 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031306AbXD2Tkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 15:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Nyy+ViF+fDSryl7RLQ7Vc/ae+3oE9hMVVzmcX3lbcbkfAO29MzF/7HWKIZOa64ZpzlVEoYn5giHyfGA7uEQTaIwxYCJ3VmTBYpickLdz4FOOj9rEjsIfIsrpHby7wYX4HiWFe85aqwGCm0TDy9cQz57/uSwIc4wpii2QzoMOD/I=
Date: Sun, 29 Apr 2007 21:40:07 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-Id: <20070429214007.9ea12e96.diegocg@gmail.com>
In-Reply-To: <20070429180909.GA30604@one.firstfloor.org>
References: <20070426224148.69b91b2e.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
	<20070428195320.GZ3468@stusta.de>
	<20070428202701.GA30343@flint.arm.linux.org.uk>
	<20070428224904.GE3468@stusta.de>
	<alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
	<p73d51n1fup.fsf@bingen.suse.de>
	<alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
	<20070429173500.GA30248@one.firstfloor.org>
	<alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
	<20070429180909.GA30604@one.firstfloor.org>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So far, it seems that most of people's opinion WRT to bug reporting and trackingcan
be divided into 2 groups:

- People who argues (and they're right) that bugzilla and web interfaces in general
  suck and that email + an "Adrian-like" solution works better

- People who argues that a bug tracker better than a mailing list is absolutely
  needed (and they're right). They also argue that while bugzilla sucks, it's
  better than nothing.

There's a common point between both groups: bugzilla sucks. The ideal
solution would be to replace bugzilla with some alternative and better
opensource bug tracking software, but I doubt it exists (there must be a
reason why everybody uses bugzilla). A good bug tracker should feel like
it makes your work easier, instead of making you feel like you're wasting
time (which is what bugzilla does)

I don't see why a web interface bug tracker should be bad for bug tracking,
as long as it's good and integrates 100% in the mailing lists. In my humble
opinion the "perfect" bug tracker for Linux should be something like this:
- Has a email interface (like the Debian bug tracking database).
- Has a web interface that completely follows the email threads
   (reading/posting), but make the comments real emails, not just
    database fields.
If done well (unlike the current bugzilla-to-email hack), it should possible
to do many nice things, like add a lkml bug report to the bug tracking
database (which shouldn't be a "real" database, but just an lkml mail
archive with a list of message IDs that are considered a bug and its state)
by just replying the thread, CCing the bug tracker and telling him to include
the thread in the database.

So unless someone is willing to write such tool (which I doubt, since it
doesn't looks easy), all this discussion seems pointless, and we should
stick with this http://kernelnewbies.org/known_regressions page
which is showing to be quite useful :)
