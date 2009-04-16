Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZDPDH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZDPDH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 23:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZDPDGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 23:06:53 -0400
Received: from kroah.org ([198.145.64.141]:52782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754350AbZDPDGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 23:06:52 -0400
Date: Wed, 15 Apr 2009 19:54:08 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090416025408.GE4806@kroah.com>
References: <20090415014930.GA29413@kroah.com> <49E5480F.10501@garzik.org> <20090415050947.GB3462@kroah.com> <49E5EE41.3090505@rtr.ca> <20090415073001.503b0361@infradead.org> <49E5FF48.3030809@rtr.ca> <20090415125813.34c9a151@infradead.org> <49E657BC.6000707@rtr.ca> <20090415183213.7962d929@infradead.org> <49E6948E.3040901@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E6948E.3040901@rtr.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 10:14:38PM -0400, Mark Lord wrote:
> Arjan van de Ven wrote:
> > On Wed, 15 Apr 2009 17:55:08 -0400
> ..
> >> No, that's not the same thing.
> >> rootwait has no timeout -- it waits *forever*,
> >> which will break auto-recovery on servers.
> > 
> > btw while I don't disagree that something like this is nice...
> > 
> > .... who would boot their server from a USB stick for production use?
> ..
> 
> At least one MAJOR storage vendor that I know of.
> Probably more.
> 
> Though it's an onboard USB SSD, not a pluggable stick.

Wow, that's insane.  Leave it to a hardware designer to use a bus that
you never know if you have discovered all the devices to be the primary
device to boot from.

greg k-h
