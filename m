Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZBNWa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZBNWa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZBNWaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:30:19 -0500
Received: from kroah.org ([198.145.64.141]:49638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752304AbZBNWaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:30:17 -0500
Date: Sat, 14 Feb 2009 14:27:41 -0800
From: Greg KH <greg@kroah.com>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Paul Mundt <lethal@users.sourceforge.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh: maple: Update the maple bus driver to support
	block reads and writes
Message-ID: <20090214222741.GA24365@kroah.com>
References: <1234641948.6609.13.camel@localhost.localdomain> <20090214215919.GA24052@kroah.com> <8b67d60902141409q39a79e67va422846f685f969d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60902141409q39a79e67va422846f685f969d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 10:09:27PM +0000, Adrian McMenamin wrote:
> 2009/2/14 Greg KH <greg@kroah.com>:
> > On Sat, Feb 14, 2009 at 08:05:48PM +0000, Adrian McMenamin wrote:
> >> Greg,
> >>
> >> This patch updates the maple bus to support asynchronous block reads and
> >> writes as well as generally improving the quality of the code and
> >> supporting concurrency (all needed to support the Dreamcast visual
> >> memory unit - a driver will also be posted for that).
> >>
> >> I have posted versions of this before but am here following the patch
> >> grouping suggested and have also tested this code and unlike earlier
> >> versions it shows no signs of suffering from race conditions - so I hope
> >> you will be happy to queue it for inclusion.
> >
> > Looks good to me, but shouldn't this go through the sh maintainers
> > instead?  This is their area, right?
> 
> 
> As it's a change to a bus I thought you were the maintainer?

Nope, just the driver core.

thanks,

greg k-h
