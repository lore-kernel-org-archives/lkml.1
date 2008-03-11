Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYCKTyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYCKTyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYCKTyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:54:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58068 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYCKTyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:54:36 -0400
Date: Tue, 11 Mar 2008 11:18:35 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] devres: implement pcim_iomap_regions_request_all()
Message-ID: <20080311181835.GA27567@kroah.com>
References: <47D6643A.6060001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D6643A.6060001@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 07:51:38PM +0900, Tejun Heo wrote:
> Some drivers need to reserve all PCI BARs to prevent other drivers
> misusing unoccupied BARs.  pcim_iomap_regions_request_all() requests
> all BARs and iomap specified BARs.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Jeff Garzik <jeff@garzik.org>
> ---
> After acked, it's probably best to push this through libata-dev as
> that's the only user for now.

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Feel free to push this through the libata-dev tree.

thanks,

greg k-h
