Return-Path: <linux-kernel-owner+w=401wt.eu-S935583AbYBAFJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935583AbYBAFJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936152AbYBAFJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:09:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44323 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764902AbYBAFJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:09:27 -0500
Date: Thu, 31 Jan 2008 21:08:18 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <james.bottomley@steeleye.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, Alan Cox <alan@redhat.com>,
       james.smart@emulex.com, linux-driver@qlogic.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 2/3] pci: Remove users of pci_enable_device_bars()
Message-ID: <20080201050818.GA23207@kroah.com>
References: <1199738907.6734.11.camel@pasglop> <20080201001445.GI19014@plap3.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201001445.GI19014@plap3.qlogic.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 04:14:45PM -0800, Andrew Vasquez wrote:
> On Tue, 08 Jan 2008, Benjamin Herrenschmidt wrote:
> 
> > On Mon, 2008-01-07 at 11:42 -0800, Andrew Vasquez wrote:
> > > That's fine.  I take it these patches will be funneled via
> > > gregkh/pci-2.6.git.  There's some qla2xxx updates which are queued for
> > > post-2.6.24 consumption in jejb/scsi-misc-2.6.git which don't appear
> > > to have any conflicts.
> > > 
> > > I do though have a series of patches which I'll hold off on submitting
> > > to linux-scsi until these PCI changes are merged, as there's some
> > > minor conflicts merging the three branches.  James B, will that be
> > > fine?
> > > 
> > > The patches themselves appear to be working fine within several of our
> > > test rings.  I hold off on some of the cleanup post-merge time...
> > 
> > Thanks for testing ! They should be queued with Greg indeed.
> 
> Just curious, this patch-set hasn't made it upstream to linux-2.6.git,
> will the work be deferred to 2.6.26??

It's less than one week into the merge window, and people are getting
worried, sheesh :)

Yes, this is queued up to go to Linus, been busy working on other issues
at the moment, don't worry, I'll make the window.  Hopefully get them
all out tomorrow...

thanks,

greg k-h
