Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbXE1RX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbXE1RX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXE1RXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:23:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60563 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbXE1RXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:23:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Date: Mon, 28 May 2007 19:29:37 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281929.38259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 17:56, Alan Stern wrote:
> On Sun, 27 May 2007, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Make it possible to register hibernation and suspend notifiers, so that
> > subsystems can perform hibernation-related or suspend-related operations that
> > should not be carried out by device drivers' .suspend() and .resume() routines.
> 
> > +static DEFINE_MUTEX(pm_notifier_lock);
> > +
> > +static RAW_NOTIFIER_HEAD(pm_chain);
> 
> Is there any particular reason you chose to use a RAW_NOTIFIER_HEAD 
> with an explicit mutex instead of using a BLOCKING_NOTIFIER_HEAD?

Hmm, not really.  I based it on the CPU hotplug notifiers, actually.

I'll see if I can use BLOCKING_NOTIFIER_HEAD.

Greetings,
Rafael
