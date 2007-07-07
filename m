Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbXGGQSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbXGGQSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 12:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXGGQSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 12:18:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1823 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750794AbXGGQSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 12:18:12 -0400
Date: Sat, 7 Jul 2007 12:17:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <1183779845.3388.206.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0707071215140.19734-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jul 2007, Benjamin Herrenschmidt wrote:

> > > And guess what ? It's what we do on powerbooks, and it works fine,
> > > without a freezer :-)

> If you remember, one of the things I've been advocating has always been
> that we should put on hold all plug activity (unplug might be alright as
> long as the user events are just delayed) when we start suspending. No
> new devices, no new bindings. "hub" type devices are respondible for
> bringing in the new stuff after resume.

Which is exactly my point.  It _doesn't_ work fine without a freezer, 
because the USB stack currently relies on the freezer to prevent plug 
activity.

Alan Stern

