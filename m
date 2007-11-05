Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXKEV5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXKEV5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXKEV4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:56:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34667 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbXKEV4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:56:53 -0500
Date: Mon, 5 Nov 2007 13:59:49 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Message-ID: <20071105215949.GA29754@kroah.com>
References: <1193848942.6621.18.camel@lov.site> <Pine.LNX.4.44L0.0711051644580.2800-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711051644580.2800-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 04:49:21PM -0500, Alan Stern wrote:
> Greg:
> 
> So what's our status?  Do you think it's worthwhile adding the 
> "drop reference to parent kobject at remove time instead of release 
> time" patch?

No.

I still need to take the time and read this thread and find the real
problem here.  The fact that the issue does not show up for other,
non-scsi block devices, makes me feel this is a scsi-specific problem
with how it deals with the driver model, but I need to take the time to
sit down and figure it out for sure.

> Also, what's the story on the updates to the USB uevent routines?  Do 
> you want separate patches from Kay and me or should we combine them 
> into a single patch?

I'll take a combined patch, as I don't think I got a signed-off for your
version, I was waiting for a "final" version.

Back to the kobject/kset cleanup/debug mess :)

thanks,

greg k-h
