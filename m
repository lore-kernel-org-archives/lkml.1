Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbXGIJOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbXGIJOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXGIJOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:14:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:54598 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXGIJOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:14:37 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <200707090847.43378.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org>
	 <1183929611.3388.303.camel@localhost.localdomain>
	 <200707090847.43378.oliver@neukum.org>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 19:13:40 +1000
Message-Id: <1183972420.5961.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 08:47 +0200, Oliver Neukum wrote:
> Am Sonntag, 8. Juli 2007 schrieb Benjamin Herrenschmidt:
> > > But I'm not sure it's a good idea in the long run.  Think of a printer 
> > > daemon, for example.  It shouldn't have to experience unexpected I/O 
> > > problems merely because someone has decided to put the system to sleep.
> > 
> > Why not ? Printer is offline when machine is asleep... trying to print
> 
> Not necessarily. The machine must survive going to sleep while you are
> printing. Any other error return than -ERESTARTSYS is not an option.
> We can't simply change the ABI.

Ugh ? Why returning an error from the printer driver to the userland
print server/daemon would prevent the machine from "surviving" ? I would
be happy with -EIO personally :-)

Ben.


