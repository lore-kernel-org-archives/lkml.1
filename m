Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZDPKw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZDPKw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZDPKws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:52:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36869 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333AbZDPKwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:52:47 -0400
Date: Thu, 16 Apr 2009 11:51:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Mark Lord <lkml@rtr.ca>, Arjan van de Ven <arjan@infradead.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090416115153.68589464@lxorguk.ukuu.org.uk>
In-Reply-To: <20090416025408.GE4806@kroah.com>
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
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Though it's an onboard USB SSD, not a pluggable stick.
> 
> Wow, that's insane.  Leave it to a hardware designer to use a bus that
> you never know if you have discovered all the devices to be the primary
> device to boot from.

Let me see:

- Standardised small component
- Low pin count and low wire count bus
- Cheap

In an embedded environment where you know the device is wired in at
software level that strikes me not as insane but very sensible.
