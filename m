Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYCMWAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYCMWAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757576AbYCMWAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:00:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42106 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbYCMWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:00:43 -0400
Date: Thu, 13 Mar 2008 14:58:42 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, stern@rowland.harvard.edu,
       linux-usb@vger.kernel.org, oliver@neukum.name
Subject: Re: 2.6.25 -- long standing bug with usb after resume with 4GB ram
Message-ID: <20080313215842.GB15029@kroah.com>
References: <20080313110141.GA4329@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313110141.GA4329@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 12:01:41PM +0100, Pavel Machek wrote:
> Hi!
> 
> There are problems with usb after suspend/resume... it works as long
> as memory is limited to 3G -- probably because iommu/agpgart/something
> is not used in such case.
> 
> rmmod/insmod of ehci_hcd & ohci_hcd fixes that.
> 
> For testing with 2.6.25, you'll need aperture_64.c patch that makes
> iommu as nosave (or it oopses).

Any pointer to where this patch is?

Can it go into 2.6.25?

thanks,

greg k-h
