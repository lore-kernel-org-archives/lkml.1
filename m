Return-Path: <linux-kernel-owner+w=401wt.eu-S964926AbZLPTZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926AbZLPTZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762885AbZLPTZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:25:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763169AbZLPTZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:25:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Wed, 16 Dec 2009 20:26:00 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912161018100.2909-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912161018100.2909-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912162026.00991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009, Alan Stern wrote:
> On Wed, 16 Dec 2009, Rafael J. Wysocki wrote:
> 
> > I measured the total time of suspending and resuming devices as shown by the
> > code added by this patch:
> > http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=commitdiff_plain;h=c1b8fc0a8bff7707c10f31f3d26bfa88e18ccd94;hp=087dbf5f079f1b55cbd3964c9ce71268473d5b67
> > on two boxes, HP nx6325 and MSI Wind U100 (hardware-wise they are quite
> > different and the HP was running 64-bit kernel and user space).
> 
> > I carried out 5 consecutive suspend-resume cycles (started from under X) on
> > each box in each case, and the raw data are here (all times in milliseconds):
> > http://www.sisk.pl/kernel/data/async-suspend.pdf
> 
> I'd like to see much more detailed data.  For each device, let's get 
> the device name, the parent's name, and the start time, end time, and 
> duration for suspend or resume.  The start time should be measured when 
> you have finished waiting for the children.  The end time should be 
> measured just before the complete_all().

I'm going to use the Arjan's patch + script to chart the suspend/resume times
for individual devices.  I can send you the raw data, though.

Rafael
