Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbXGHAnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbXGHAnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 20:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbXGHAnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 20:43:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:33009 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbXGHAnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 20:43:06 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.0707071215140.19734-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0707071215140.19734-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 10:42:42 +1000
Message-Id: <1183855362.3388.233.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-07 at 12:17 -0400, Alan Stern wrote:
> On Sat, 7 Jul 2007, Benjamin Herrenschmidt wrote:
> 
> > > > And guess what ? It's what we do on powerbooks, and it works fine,
> > > > without a freezer :-)
> 
> > If you remember, one of the things I've been advocating has always been
> > that we should put on hold all plug activity (unplug might be alright as
> > long as the user events are just delayed) when we start suspending. No
> > new devices, no new bindings. "hub" type devices are respondible for
> > bringing in the new stuff after resume.
> 
> Which is exactly my point.  It _doesn't_ work fine without a freezer, 
> because the USB stack currently relies on the freezer to prevent plug 
> activity.

Putting on hold plug activity has nothing, NOTHING, to do with the half
assed piece of deadlocking crap we have now we call a freezer.

As long as you guys keep mixing up all the issues and coming up with
totally bogus solutions that cannot work, we won't have a useful suspend
(either to RAM or to disk) in linux.

Ben.


