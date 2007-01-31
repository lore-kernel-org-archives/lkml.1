Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXAaGNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXAaGNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 01:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932911AbXAaGNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 01:13:53 -0500
Received: from mx1.suse.de ([195.135.220.2]:37770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbXAaGNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 01:13:52 -0500
Date: Tue, 30 Jan 2007 22:12:53 -0800
From: Greg KH <greg@kroah.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Reducing warning output from pci_get_subsys()
Message-ID: <20070131061253.GA2638@kroah.com>
References: <Pine.LNX.4.64.0701302251520.5644@localhost.localdomain> <20070130211153.4ca1aaa7.akpm@osdl.org> <6543410C-B60C-4706-AB4E-FA64C4E592F5@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6543410C-B60C-4706-AB4E-FA64C4E592F5@kernel.crashing.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 11:18:21PM -0600, Kumar Gala wrote:
> 
> On Jan 30, 2007, at 11:11 PM, Andrew Morton wrote:
> 
> >On Tue, 30 Jan 2007 22:55:38 -0600 (CST)
> >Kumar Gala <galak@kernel.crashing.org> wrote:
> >
> >>Greg,
> >>
> >>There was some code added to warn if pci_get_subsys() is called  
> >>and the
> >>pci_devices is empty.
> >>
> >>I'm wondering if there is some point at which we know its ok for the
> >>pci_devices list be empty if there are no devices on the bus so we  
> >>can
> >>stop printing the message.
> >>
> >>On an embedded PPC reference system I see this message 6 times  
> >>when I've
> >>got no cards in the PCI slots.
> >>
> >
> >I'd suggest we just remove the warning.  Also the one in  
> >pci_find_subsys().
> >
> >I let them go through because I was curious to know what would  
> >cause it to
> >trigger - it might be an indication of other bugs.  But nothing very
> >interesting happened and they're of no use.
> 
> Works for me.

No objection from me either.

thanks,

greg k-h
