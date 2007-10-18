Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbXJRO3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbXJRO3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763664AbXJRO24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:28:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49026 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760264AbXJRO2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:28:55 -0400
Date: Thu, 18 Oct 2007 10:28:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Miller <davem@davemloft.net>
cc: david-b@pacbell.net, <linux-usb-users@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <greg@kroah.com>
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
In-Reply-To: <20071017.160336.95505053.davem@davemloft.net>
Message-ID: <Pine.LNX.4.44L0.0710181027220.4434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, David Miller wrote:

> From: Alan Stern <stern@rowland.harvard.edu>
> Date: Wed, 17 Oct 2007 11:51:57 -0400 (EDT)
> 
> > > +			break;
> > > +	}
> > > +	if (limit_1 < 0) {
> > > +		ohci_warn(ohci, "Root port outer-loop reset timeout, "
> > > +			  "now[%04x] reset_done[%04x]\n",
> > > +			  now, reset_done);
> > > +	}
> > 
> > What reason is there for having two warning messages?  One ought to be 
> > enough.
> 
> In my patch it was possible for the inner loop one to succeed, but the
> outer one to not do so.
> 
> In your's this is not the case so I guess it's OK.
> 
> I wonder if it's so wise trying to do two things at once.  Here we are
> adding the loop timeouts, and also changing to using jiffies based
> timeouts rather than a chip timer register based one.
> 
> I preferred my patches because it solved one single problem, the lack
> of loop limits.  The timeout mechanism could have been changed in
> another followon patch.

At this point I'd be perfectly happy to sit back and let David B.
choose, among all the possibilities that have been posted, the one he
thinks is best.

Alan Stern

