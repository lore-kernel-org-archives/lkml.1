Return-Path: <linux-kernel-owner+w=401wt.eu-S1763628AbXHYA1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763628AbXHYA1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbXHYA1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:27:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40388 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbXHYA1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:27:45 -0400
Date: Fri, 24 Aug 2007 17:15:59 -0700
From: Greg KH <greg@kroah.com>
To: tonyj@suse.de
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, kay.sievers@vrfy.org
Subject: Re: [patch 11/14] Convert from class_device to device for USB host
Message-ID: <20070825001559.GA3749@kroah.com>
References: <20070820224806.154198000@suse.de> <20070820225131.546468000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820225131.546468000@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 03:48:17PM -0700, tonyj@suse.de wrote:
> -- 
> Content-Disposition: inline; filename=usb-host.patch
> 
> Convert from class_device to device for drivers/ide/usb/host.   Greg, not
> sure if you're looking for a patch for this. Kay mentioned maybe it was to
> be superceded by a diff mechanism.  Free free to drop if so. Thanks!

Yeah, these files all need to go to debugfs, not stay as sysfs files.
If you want to do that, that would be wonderful, I'd really appreciate
it.  Otherwise it's going to be a few weeks before I can do this.

thanks,

greg k-h
