Return-Path: <linux-kernel-owner+w=401wt.eu-S1765653AbYDOVxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765653AbYDOVxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbYDOVxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:53:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:53642 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbYDOVxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:53:19 -0400
Subject: Re: pci: add to global list before sysfs?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <gregkh@suse.de>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080415191333.GA28671@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
	 <20080404210132.GA14418@suse.de> <1208122538.6958.57.camel@pasglop>
	 <20080415191333.GA28671@suse.de>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 07:53:07 +1000
Message-Id: <1208296387.6958.239.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-15 at 12:13 -0700, Greg KH wrote:
> > Haven't had a chance to look at your changes yet, but I have memories of
> > being pretty happy with having that 2 step mechanism in PCI where the
> > driver core would only see the devices after fixup.
> 
> No, that is left alone, I just dropped the duplicate device list that
> was linked within the PCI devices themselves.  The only user of it was
> the "reorder the PCI devices" code for some Dell machines, and that was
> just doing it to be safe (it was also reordering the driver core list of
> PCI devices, which is what really mattered.)
> 
> So everything should still be fine.

Ok, thanks.

Cheers,
Ben.


