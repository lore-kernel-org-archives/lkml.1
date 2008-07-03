Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYGCU04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYGCU04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYGCU0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:26:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYGCU0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:26:46 -0400
Date: Thu, 3 Jul 2008 13:24:46 -0700
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] PCI: make pci_name use dev_name
Message-ID: <20080703202446.GB528@kroah.com>
References: <20080702153524.GA30318@kroah.com> <20080702160422.GA2655@suse.de> <20080702202200.GA14021@kroah.com> <200807031237.31063.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807031237.31063.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 12:37:30PM -0700, Jesse Barnes wrote:
> On Wednesday, July 02, 2008 1:22 pm Greg KH wrote:
> > On Wed, Jul 02, 2008 at 09:04:22AM -0700, Greg KH wrote:
> > > Well, it's only used in 837 different places, so it might take me a few
> > > hours to ensure I catch all the usages :(
> >
> > Ok, here are 4 patches that fix the few places that this pci change
> > caused problems.
> >
> > Jesse, do you want to add these to your tree?  I can take the single USB
> > one if you want, or you can take all 4, it's fine with me.
> 
> I'd rather just take the PCI patch (which I'm doing now).  The other stuff can 
> come in through the appropriate tree.

Fair enough, I'll make sure they don't get dropped.

thanks,

greg k-h
