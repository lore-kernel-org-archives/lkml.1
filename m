Return-Path: <linux-kernel-owner+w=401wt.eu-S1762418AbXE1LRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762418AbXE1LRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXE1LRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:17:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbXE1LRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:17:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 13:22:51 +0200
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <200705272345.04518.rjw@sisk.pl> <1180341026.14749.12.camel@nigel.suspend2.net>
In-Reply-To: <1180341026.14749.12.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281322.52854.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 10:30, Nigel Cunningham wrote:
> Hi.
> 
> On Sun, 2007-05-27 at 23:45 +0200, Rafael J. Wysocki wrote:
> > On Sunday, 27 May 2007 22:49, Matthew Garrett wrote:
> > > On Sun, May 27, 2007 at 10:31:53PM +0200, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Use a hibernation and suspend notifier to disable the firmware requesting
> > > > mechanism before a hibernation/suspend and enable it after the operation.
> > > 
> > > This avoids the problem of .resume methods calling userspace while 
> > > userspace is frozen and a resulting hang, but does it actually result in 
> > > the drivers beginning to work again?
> > 
> > Well, this was acutally invented before you've decided to remove the freezing
> > of tasks from the suspend code path (which I think is a mistake, but that's
> > only my personal opinion, so it doesn't matter very much ;-)) and I regard it
> > as a workaround.
> 
> Suspend-to-ram code paths shouldn't assume userspace is unfrozen anyway.
> Doesn't [u]swsusp have a code path like Suspend2 where we can suspend to
> ram after writing the hibernation image? In that case, it will still be
> possible that we seek to enter and leave S3 with processes frozen.

That's correct.

> Apologies if anyone has already mentioned this - I'm just starting to
> play catchup.

No one has and that's a valid point, I think. :-)

Greetings,
Rafael
