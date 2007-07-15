Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbXGOXP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbXGOXP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbXGOXPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:15:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2283 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756185AbXGOXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:15:50 -0400
Date: Sun, 15 Jul 2007 19:15:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: david@lang.hm
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.64.0707151538130.25614@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0707151914450.28934-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007 david@lang.hm wrote:

> >> for a pure hibernate mode, you will be powering off the box after saving
> >> the suspend image. why are there any special ACPI modes involved?
> >
> > Because, for example, on my machine the status of power supply (present
> > vs not present) is not updated correctly after the restore if ACPI callbacks
> > aren't used during the hibernation.  That's just experience and it's in line
> > with the ACPI spec.
> 
> so if a machine is actually powered off the /dev/suspend process won't 
> work?
> 
> remember that the system may run a different OS between the hibernate and 
> the resume, makeing any assumptions about what state the hardware is in 
> when you start the resume is a problem.

As I understand it, running a different OS between the hibernate and 
the resume would violate the ACPI spec.

Alan Stern

