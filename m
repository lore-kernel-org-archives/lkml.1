Return-Path: <linux-kernel-owner+w=401wt.eu-S936480AbXGQVie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936480AbXGQVie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934048AbXGQVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:37:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936090AbXGQVhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:37:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 23:45:42 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0707171414370.2467@asgard.lang.hm> <871wf6g1q1.fsf@jbms.ath.cx>
In-Reply-To: <871wf6g1q1.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172345.43574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 23:27, Jeremy Maitin-Shepard wrote:
> david@lang.hm writes:
> 
> [snip]
> 
> >> How do you guarantee that no tasks are scheduled when you get back to the
> >> hibernated kernel?
> 
> > just don't schedule any userspace tasks. all you need to do is to execute the
> > ACPI sleep functions. you normally do that after stopping userspace
> > anyway.
> 
> What does "stopping userspace" mean?  You already said it does not mean
> disabling interrupts.  But using the freezer is also not an option,
> since the avoidance of that is the main reason for the kexec approach in
> the first place.
> 
> [snip]
> 
> >> Well, not exactly.  If your battery runs out of power while you're suspended,
> >> but you have the image saved, it's still better to restore from the image,
> > even
> >> if something may not work correctly after the restore, than to risk a loss of
> >> data.
> 
> > if things don't work correctly you are still risking the loss of data, the user
> > just doesn't know it.
> 
> It should be possible on any system to do a hibernate followed by a
> shutdown (and then resume properly, without any problems).  Thus, for
> handling suspend to both, you resume as if the system had been shutdown,
> rather than resuming as if the system came from S4.

Exactly.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
