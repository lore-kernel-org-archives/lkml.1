Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZDPNcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZDPNcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZDPNco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:32:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:54425 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbZDPNcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:32:43 -0400
Date: Thu, 16 Apr 2009 06:34:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Mark Lord <lkml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090416063401.32ced22a@infradead.org>
In-Reply-To: <20090416115153.68589464@lxorguk.ukuu.org.uk>
References: <20090415014930.GA29413@kroah.com>
	<49E5480F.10501@garzik.org>
	<20090415050947.GB3462@kroah.com>
	<49E5EE41.3090505@rtr.ca>
	<20090415073001.503b0361@infradead.org>
	<49E5FF48.3030809@rtr.ca>
	<20090415125813.34c9a151@infradead.org>
	<49E657BC.6000707@rtr.ca>
	<20090415183213.7962d929@infradead.org>
	<49E6948E.3040901@rtr.ca>
	<20090416025408.GE4806@kroah.com>
	<20090416115153.68589464@lxorguk.ukuu.org.uk>
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

On Thu, 16 Apr 2009 11:51:53 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Though it's an onboard USB SSD, not a pluggable stick.
> > 
> > Wow, that's insane.  Leave it to a hardware designer to use a bus
> > that you never know if you have discovered all the devices to be
> > the primary device to boot from.
> 
> Let me see:
> 
> - Standardised small component
> - Low pin count and low wire count bus
> - Cheap
> 
> In an embedded environment where you know the device is wired in at
> software level that strikes me not as insane but very sensible.

I'm not surprised usb is used for storage. What I am surprised at is
that USB is used in such high end environments that rootwait is not
sufficient and that the panic-rebooter is needed for the reliability.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
