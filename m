Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbXLURy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbXLURy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 12:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbXLURyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 12:54:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58997 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXLURyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 12:54:19 -0500
Date: Fri, 21 Dec 2007 09:40:46 -0800
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, Alan Cox <alan@redhat.com>,
       james.smart@emulex.com, linux-driver@qlogic.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 3/3] pci: Remove pci_enable_device_bars()
Message-ID: <20071221174046.GA26965@kroah.com>
References: <20071220042812.706D0DDEE7@ozlabs.org> <20071221042855.GF25341@kroah.com> <1198212448.6779.45.camel@pasglop> <20071221051139.GA23507@kroah.com> <1198215131.6779.49.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198215131.6779.49.camel@pasglop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 04:32:11PM +1100, Benjamin Herrenschmidt wrote:
> 
> On Thu, 2007-12-20 at 21:11 -0800, Greg KH wrote:
> > On Fri, Dec 21, 2007 at 03:47:28PM +1100, Benjamin Herrenschmidt wrote:
> > > pci: Remove pci_enable_device_bars() fix for qla
> > > 
> > > The previous patch missed one occurence of pci_enable_device_bars()
> > > in the qla2xxx driver. This fixes it.
> > 
> > Should I just merge this with your 2/3 patch so everything is sane?
> 
> Sure.

Ok, now merged and pushed out, thanks.

greg k-h
