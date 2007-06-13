Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbXFMSaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbXFMSaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbXFMSaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:30:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:53884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758657AbXFMSaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:30:20 -0400
Date: Wed, 13 Jun 2007 11:32:00 -0700
From: Greg KH <gregkh@suse.de>
To: holzheu <holzheu@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070613183200.GA16588@suse.de>
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613175147.GB14355@suse.de> <1181758680.26375.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181758680.26375.25.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 08:18:00PM +0200, holzheu wrote:
> Hi Greg,
> 
> > Ick, why are you ignoring what we have already with dev_printk() and
> > friends?  We are just finally getting developers to use that, I think it
> > will be almost impossible to get people to change to something else,
> > especially one that isn't even as "correct" as what dev_printk() offers
> > you today, will be quite hard.
> >
> > So, why not use what we already have and work off of it?
> 
> dev_printk() and friends are great, since they already define something
> like KMSG_COMPONENT: The driver name.

They provide way more than that, they also provide the explicit device
that is being discussed, as well as other things depending on the
device.

So if you are going to do this, please use the already-in-place macros
to hook into, don't try to get the driver authors to pick up something
new and different, as it's going to be _very_ difficult, trust me...

thanks,

greg k-h
