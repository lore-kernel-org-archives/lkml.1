Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbXGIKGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbXGIKGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXGIKFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:05:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:39228 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXGIKFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:05:52 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20070709100204.GN5401@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org>
	 <1183929611.3388.303.camel@localhost.localdomain>
	 <200707090847.43378.oliver@neukum.org>  <20070709100204.GN5401@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 20:05:22 +1000
Message-Id: <1183975522.5961.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 12:02 +0200, Pavel Machek wrote:
> Hi!
> 
> > > > But I'm not sure it's a good idea in the long run.  Think of a printer 
> > > > daemon, for example.  It shouldn't have to experience unexpected I/O 
> > > > problems merely because someone has decided to put the system to sleep.
> > > 
> > > Why not ? Printer is offline when machine is asleep... trying to print
> 
> ...filesystems are offline, too, when the machine is asleep. Yet,
> unmounting everything on suspend would not result in useful suspend
> support.
> 
> Yes, I believe we should be transparent.

You just compared apple and oranges... Try printing and half way through
the page, suspend your USB bus, and see how the printer reacts.

Ben.


