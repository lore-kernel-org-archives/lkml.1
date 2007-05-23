Return-Path: <linux-kernel-owner+w=401wt.eu-S1762988AbXEWPOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762988AbXEWPOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbXEWPOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:14:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44157 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbXEWPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:14:43 -0400
Date: Wed, 23 May 2007 08:14:26 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race free attributes in sysfs
Message-ID: <20070523151426.GB26046@kroah.com>
References: <46502A8B.70803@drzeus.cx> <200705202312.19191.dtor@insightbb.com> <46535F7F.1040504@rtr.ca> <200705222243.56007.dtor@insightbb.com> <20070523042145.GA27329@kroah.com> <46544130.1010901@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46544130.1010901@rtr.ca>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 09:27:12AM -0400, Mark Lord wrote:
>  Greg KH wrote:
> > And yes, it only starts to look for things when it recieves an event, it
> > does not "scan" sysfs at all.
> 
>  Does it "look for" only that one event, or does it "scan" at that point?

udev will act on that event, and as I mentioned, not read anything from
sysfs at all, unless a custom rule is in the rules file asking it to
read a specific sysfs file in the tree.

So no "scanning" happens unless specificically asked for.

And as mentioned, udev can work just fine without sysfs enabled at all
now, with the exception of some custom rules for some devices.

thanks,

greg k-h
