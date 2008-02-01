Return-Path: <linux-kernel-owner+w=401wt.eu-S934861AbYBAAPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861AbYBAAPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYBAAPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:15:00 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:52165 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbYBAAO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:14:59 -0500
Date: Thu, 31 Jan 2008 16:14:45 -0800
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: James Bottomley <james.bottomley@steeleye.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, Alan Cox <alan@redhat.com>,
       james.smart@emulex.com, linux-driver@qlogic.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 2/3] pci: Remove users of pci_enable_device_bars()
Message-ID: <20080201001445.GI19014@plap3.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199738907.6734.11.camel@pasglop>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 01 Feb 2008 00:14:57.0215 (UTC) FILETIME=[7A0D24F0:01C86467]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2008, Benjamin Herrenschmidt wrote:

> On Mon, 2008-01-07 at 11:42 -0800, Andrew Vasquez wrote:
> > That's fine.  I take it these patches will be funneled via
> > gregkh/pci-2.6.git.  There's some qla2xxx updates which are queued for
> > post-2.6.24 consumption in jejb/scsi-misc-2.6.git which don't appear
> > to have any conflicts.
> > 
> > I do though have a series of patches which I'll hold off on submitting
> > to linux-scsi until these PCI changes are merged, as there's some
> > minor conflicts merging the three branches.  James B, will that be
> > fine?
> > 
> > The patches themselves appear to be working fine within several of our
> > test rings.  I hold off on some of the cleanup post-merge time...
> 
> Thanks for testing ! They should be queued with Greg indeed.

Just curious, this patch-set hasn't made it upstream to linux-2.6.git,
will the work be deferred to 2.6.26??

--
av
