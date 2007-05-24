Return-Path: <linux-kernel-owner+w=401wt.eu-S1750995AbXEXNzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995AbXEXNzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750723AbXEXNzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:55:39 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:44118 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXEXNzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:55:38 -0400
Date: Wed, 23 May 2007 21:20:55 -0400
From: David Hollis <dhollis@davehollis.com>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the	-stable
 cycle
In-reply-to: <20070522221718.GC2302@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Message-id: <1179969655.4489.3.camel@dhollis-lnx.sunera.com>
MIME-version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com>
	<46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com>
	<20070522195135.GG12157@redhat.com>  <20070522221718.GC2302@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 15:17 -0700, Greg KH wrote:

> > 
> > Theres more to this than just PCI IDs though.
> > ac97 ID updates, usb id updates, etc, etc.
> 
> USB ids also can be added through sysfs :)
> 

FWIW,

With the asix.c driver, you can't just add the USB IDs and have it work.
Each ID also needs to be told which driver structure to use, since the
driver itself supports three similar, but distinct chips.  Adding the
IDs to the driver itself is naturally trivial, but adding via sysfs or
the like doesn't work.  I would imagine that there are other drivers
that operate quite similarly.


-- 
David Hollis <dhollis@davehollis.com>

