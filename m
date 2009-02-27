Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbZB0HKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbZB0HKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZB0HKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:10:22 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35448 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbZB0HKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:10:18 -0500
Date: Fri, 27 Feb 2009 16:06:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh: maple: Update the maple bus driver to support block reads and writes
Message-ID: <20090227070634.GC28802@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Greg KH <greg@kroah.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1234641948.6609.13.camel@localhost.localdomain> <1234642605.6609.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234642605.6609.17.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 08:16:45PM +0000, Adrian McMenamin wrote:
> On Sat, 2009-02-14 at 20:06 +0000, Adrian McMenamin wrote:
> > Greg,
> > 
> > This patch updates the maple bus to support asynchronous block reads and
> > writes as well as generally improving the quality of the code and
> > supporting concurrency (all needed to support the Dreamcast visual
> > memory unit - a driver will also be posted for that).
> > 
> > I have posted versions of this before but am here following the patch
> > grouping suggested and have also tested this code and unlike earlier
> > versions it shows no signs of suffering from race conditions - so I hope
> > you will be happy to queue it for inclusion.
> > 
> > Changes in the bus driver necessitate some changes in the two maple bus
> > input drivers that are currently in mainline.
> > 
> > (Maple is SEGA's proprietary serial bus for the Dreamcast. It is capable
> > of comm speeds of up to 2Mbs.)
> > 
> > As well as supporting block reads and writes this code clean up removes
> > some poor handling of locks, uses an atomic status variable to serialise
> > access to devices and more robusly handles the general performance
> > problems of the bus.
> > 
> Apologies, some of the VMU patch slipped into that. Here is a completely
> clean version.
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Applied, thanks.
