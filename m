Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZDOT5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZDOT5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZDOT5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:57:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:54017 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZDOT47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:56:59 -0400
Date: Wed, 15 Apr 2009 12:58:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415125813.34c9a151@infradead.org>
In-Reply-To: <49E5FF48.3030809@rtr.ca>
References: <49E4FAC6.1030400@garzik.org>
	<20090415014930.GA29413@kroah.com>
	<49E5480F.10501@garzik.org>
	<20090415050947.GB3462@kroah.com>
	<49E5EE41.3090505@rtr.ca>
	<20090415073001.503b0361@infradead.org>
	<49E5FF48.3030809@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 11:37:44 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Arjan van de Ven wrote:
> > On Wed, 15 Apr 2009 10:25:05 -0400
> > Mark Lord <lkml@rtr.ca> wrote:
> > 
> >> Greg KH wrote:
> >>> ..
> >>> The issue is that you were just lucky that your machine worked
> >>> properly previously.  My boxes with the same type of setup didn't,
> >>> so I quickly realized what the root delay boot option was for.
> >>> You need to just do the same thing here, there's nothing else we
> >>> can do.
> >> ..
> >>
> >> Bad excuse.
> >>
> >> SATA drives also take variable amounts of time to "show up" at
> >> boot. Perhaps Jeff should customize libata for your and Arjan's
> >> exact setups, just to help with understanding the point here.  :)
> > 
> > the difference is that with sata you know when you are done and
> > have all possible drives. No so much much with USB. So with SATA we
> > can, and do, wait for the scan to complete at the right point in
> > the boot.
> > 
> >> The speed ups are fine (and welcome), but we really now need
> >> Arjan to follow-up with a patch to have the kernel *by default*
> >> wait a little longer for the rootfs to show up.
> >>
> >> Not forever, just a few seconds to compensate for the regression.
> > 
> > seconds!!!!!
> > The whole kernel boots in half a second!
> ..
> 
> Oh, absolutely I agree.
> 
> That's why I'm not suggesting a DELAY
> but rather a TIMEOUT (where it keeps trying up until the timeout).

This exists today. It's just not something Jeff chose to use ;)
(because he didn't need to)

> 
> For desktop, it should really just wait forever,
> but I can understand situations (server room)
> where that would be a Really Bad Idea.

it's called rootwait and such :)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
