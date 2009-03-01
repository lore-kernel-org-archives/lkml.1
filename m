Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbZCAGfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbZCAGfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 01:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZCAGf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 01:35:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:41666 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZCAGf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 01:35:26 -0500
Subject: Re: [RFD] Automatic suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
In-Reply-To: <d6200be20902281606g1c5db332r9970931d7080717f@mail.gmail.com>
References: <200902192215.18365.rjw@sisk.pl>
	 <200902281118.14595.rjw@sisk.pl>
	 <d6200be20902281357r2d3a0075q77055c1781f174d7@mail.gmail.com>
	 <200902282353.39763.rjw@sisk.pl>
	 <d6200be20902281606g1c5db332r9970931d7080717f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Mar 2009 17:28:43 +1100
Message-Id: <1235888923.7388.121.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-28 at 16:06 -0800, Arve Hjønnevåg wrote:

I'm not taking a position on the merit of the wakelocks per se nor
whether Rafael is right or wrong here, I haven't looked at the problem
closely enough. I just want to react to this:

> The basic concept was developed long before android was a public
> project.

This isn't going to bring you any good will. We don't care what was done
before it was a public project. That has strictly no relevance to how it
should be submitted upstream.

How long the code has been simmering internally to company X or Y or
even in a public tree doesn't matter. Some times, yes, we do take
something as a whole, when it makes no sense to do otherwise (a driver,
a filesystem, ...). 

But something like what you propose, it seems, could easily be broken
down into a basic concept, on which features are added one after the
other, and in this case, it's the right way to go, simply because it's
easier to argue for the basic concept alone if you don't have to handle
comments froms people who don't agree with aspect A B or C of the other
features involved.

And if the basic concept doesn't get accepted in the first place, then
the whole point is moot...

Cheers,
Ben.


