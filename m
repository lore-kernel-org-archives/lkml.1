Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYF0OmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYF0OmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYF0Oly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:41:54 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34541 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755974AbYF0Olx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:41:53 -0400
Subject: Current List of Kernel Summit suggested topics from the discuss
	list
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: ksummit-2008-discuss@lists.linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 09:41:49 -0500
Message-Id: <1214577710.3394.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This is the synopsis of the currently suggested topics so far.  That's
not to say this is the list we will be doing, just to say that if
there's something you think we should be discussing and it's not on the
list, now would be a good time to add it (don't trust the programme
committee magically to add it at the last minute ...)

James

---

Meta Topics:

     1. Do KS as an unconference - Matthew Wilcox
     2. Do a Mini Hackfest for 50% of the time - Greg KH
     3. Expand to three days and do Tech/Process/Tech on each day - Dave
        Miller

Agenda Topics:

     1. Asynchronous Operations - Ulrich Drepper
              * How do we make programs more parallel (driven by
                multicore)
              * Can we use tasklets for this
     2. Fixing the Kernel Janitor's Project - James Bottomley
              * KJ Isn't a good intro to kernel hacking, need better
                ones like bug finding and fixing.
              * Need to find more ways for non coders to make useful
                contributions
              * Need to think more about what 'useful contributions' are
              * What about the kernel tester's project [Adrian Bunk]
     3. Moving firmware Blobs out of the Kernel - David Woodhouse
              * remove all firmware and repackage in ways that would
                either be pulled in at runtime or could be linked into
                the kernel (distro choice)
              * Need to be careful about licensing compatibility
              * Where should we actually keep the extracted firmware
     4. Barriers - Neil Brown
              * Need to define what semantics filesystems actually want
              * Need to relate this to what devices and subsystems can
                actually provide.
     5. Tracking Regressions - Rafael Wysocki
              * Describe experiences with the current running of the
                regression lists
              * How could we make the current list and practice more
                useful
     6. Discuss new Suspend/Resume Framework - Rafael Wysocki
              * Discuss semantics of what drivers should be expecting
                and what best practices are.
              * Need better documentation on this
              * can we make subsystem libraries of helpers for their
                driver suspend/resume to ease the pain?
     7. Hack/Fix session for Laptop Suspend and NOHZ/idle - Thomas
        Gleixner
              * Perhaps this should be done at Plumbers instead
     8. Content Accessed Filesystems - Lars Noschinski
              * Filesystem that would store the same block only once
              * Would be useful for git [Pavel Machek]
     9. When should Drivers be Merged - James Bottomley
              * Options seem to be ASAP, Wait for a bit for it to
                mature, when the vendor has fixed the obvious bugs
              * Have a fast submission track for drivers for which the
                hardware documentation is available [Tony Luck]
              * Run driver submissions early through staging trees while
                they get fixed
                      * How should these be run? Centrally or in
                        subsystem trees
                      * Should staging trees be part of linux-next


