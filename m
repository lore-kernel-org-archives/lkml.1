Return-Path: <linux-kernel-owner+w=401wt.eu-S935974AbZLQBaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935974AbZLQBaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935950AbZLQB34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:29:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60046 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935967AbZLQB3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:29:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Thu, 17 Dec 2009 02:30:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912161753540.2643-100000@iolanthe.rowland.org> <200912170018.05175.rjw@sisk.pl>
In-Reply-To: <200912170018.05175.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912170230.24147.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 December 2009, Rafael J. Wysocki wrote:
> On Thursday 17 December 2009, Alan Stern wrote:
> > On Wed, 16 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > > I've just put the first set of data, for the HP nx6325 at:
> > > http://www.sisk.pl/kernel/data/nx6325/
> > >  
> > > The *-dmesg.log files contain full dmesg outputs starting from a cold boot and
> > > including one suspend-resume cycle in each case, with debug_initcall enabled.
> > > 
> > > The *-suspend.log files are excerpts from the *-dmesg.log files containing
> > > the suspend messages only, and analogously for *-resume.log.
> > 
> > I've just started looking at the sync-suspend.log file.  What are all 
> > the '+' characters and " @ 3368" strings after the device names?
> 
> I think the + is necessary for the Arjan's graph-generating script and the
> @ number is the value of current (ie. the PID of the calling task).
> 
> > You didn't print out the parent name for each device, so the tree 
> > structure has been lost.
> 
> That's because the original Arjan's patch doesn't do that, I'm adding it
> right now.
> 
> > Why do those "sd 0:0:0:0 [sda]" messages appear in between two 
> > callbacks?  The cache-synchronization and the spin-down commands are
> > not executed asynchronously.
> 
> Because the data are incomplete.  :-(
> 
> I've just realized that the Arjan's patch only covers bus types and classes
> that have been converted to dev_pm_ops already, so I'm extending it to the
> "legacy" ones at the moment.

New data files have been uploaded to:

http://www.sisk.pl/kernel/data/nx6325/
http://www.sisk.pl/kernel/data/wind/

Please let me know if you need more information.

Rafael
