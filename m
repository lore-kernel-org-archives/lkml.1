Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbXGIJYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbXGIJYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXGIJYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:24:08 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:41216 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbXGIJYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:24:07 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Mon, 9 Jul 2007 11:23:56 +0200
User-Agent: KMail/1.9.7
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org> <200707090847.43378.oliver@neukum.org> <1183972420.5961.26.camel@localhost.localdomain>
In-Reply-To: <1183972420.5961.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707091123.57400.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 9. Juli 2007 schrieb Benjamin Herrenschmidt:
> On Mon, 2007-07-09 at 08:47 +0200, Oliver Neukum wrote:
> > Am Sonntag, 8. Juli 2007 schrieb Benjamin Herrenschmidt:
> > > > But I'm not sure it's a good idea in the long run.  Think of a printer 
> > > > daemon, for example.  It shouldn't have to experience unexpected I/O 
> > > > problems merely because someone has decided to put the system to sleep.
> > > 
> > > Why not ? Printer is offline when machine is asleep... trying to print
> > 
> > Not necessarily. The machine must survive going to sleep while you are
> > printing. Any other error return than -ERESTARTSYS is not an option.
> > We can't simply change the ABI.
> 
> Ugh ? Why returning an error from the printer driver to the userland
> print server/daemon would prevent the machine from "surviving" ? I would
> be happy with -EIO personally :-)

Surviving is a bit strongly worded.

Suspension is to be transparent. Apart from a jump in the system clock
user space must not notice, thus returning errors due to suspension is
not an option.

	Regards
		Oliver

