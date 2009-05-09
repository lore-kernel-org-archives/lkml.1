Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZEIFDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZEIFDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 01:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZEIFDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 01:03:14 -0400
Received: from kroah.org ([198.145.64.141]:51217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbZEIFDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 01:03:14 -0400
Date: Fri, 8 May 2009 21:34:22 -0700
From: Greg KH <greg@kroah.com>
To: Robert Mykland <robert@ascenium.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Vendor info from device name
Message-ID: <20090509043422.GA13794@kroah.com>
References: <4A04CB41.3040008@ascenium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A04CB41.3040008@ascenium.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 05:16:01PM -0700, Robert Mykland wrote:
> Hi Folks,
> 
> I am inside a file system driver, a modified version of vfat to be 
> exact, trying to get vendor info that uniquely identifies a USB storage 
> device that's associated.  I have the device name coming into 
> vfat_get_sb().  I looked down through the associated structures I get 
> here but nothing obvious pops out.  What's the best way to get down to 
> the vendor/unique device info from here?  Thanks in advance for your 
> help and apologies in advance if this is a dumb question.

Do this from userspace, with the tools provided in the udev package,
vol_id and friends.

Why would you want to do this within the kernel?

thanks,

greg k-h
