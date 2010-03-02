Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0CBXLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:11:09 -0500
Received: from kroah.org ([198.145.64.141]:34478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab0CBXLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:11:05 -0500
Date: Tue, 2 Mar 2010 15:10:59 -0800
From: Greg KH <greg@kroah.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: linux-next: manual merge of the usb tree with the block tree
Message-ID: <20100302231059.GA32440@kroah.com>
References: <20100301185441.06014ba8.sfr@canb.auug.org.au>
 <20100301080402.GP5768@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301080402.GP5768@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 09:04:03AM +0100, Jens Axboe wrote:
> On Mon, Mar 01 2010, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/usb/storage/scsiglue.c between commit
> > 086fa5ff0854c676ec333760f4c0154b3b242616 ("block: Rename
> > blk_queue_max_sectors to blk_queue_max_hw_sectors") from the block tree
> > and commit 628726dbb5ebbec77336019ac4e1f60cf3ba08c1 ("usb-storage: use
> > max_hw_sectors instead of max_sectors") from the usb tree.
> > 
> > Just context changes.  I fixed it up (see below) and can carry the fix as
> > necessary.
> 
> Thanks Stephen, looks good.

I've made these changes in the patch set I sent to Linus.

thanks,

greg k-h
