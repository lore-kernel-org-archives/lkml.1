Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYBXWUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYBXWUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYBXWUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:20:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54710 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbYBXWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:20:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Sun, 24 Feb 2008 23:18:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
References: <Pine.LNX.4.44L0.0802241605340.17767-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802241605340.17767-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802242318.51988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Alan Stern wrote:
> On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Remove the code that acquires all device semaphores from the suspend
> > code path as it causes multiple problems to appear (most notably,
> > http://bugzilla.kernel.org/show_bug.cgi?id=10030) and revert the
> > change introduced by commit 4145ed6dc597a9bea5f6ae8c574653b2de10620f
> > depending on the code being removed.
> > 
> > Remove pm_sleep_lock()/pm_sleep_unlock() from device_add() to avoid
> > the issue reported at http://bugzilla.kernel.org/show_bug.cgi?id=9874.
> 
> This looks okay.
> 
> Are you going to submit it just for 2.6.25, leaving the existing code 
> as-is for 2.6.26?

No, I'd like to start over on top of 2.6.25.  That will be much cleaner from
the upstream point of view.

We seem to have all the pieces anyway, so that's only a matter of putting them
back together.

Thanks,
Rafael
