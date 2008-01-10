Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYAJTx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYAJTx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYAJTxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:53:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:38260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbYAJTxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:53:50 -0500
Date: Thu, 10 Jan 2008 11:54:03 -0800
From: Greg KH <gregkh@suse.de>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: linux-kernel@vger.kernel.org, linux@sierrawireless.com,
       linux-usb@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Message-ID: <20080110195403.GA29384@suse.de>
References: <1199992265.9266.19.camel@linux-z60t>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199992265.9266.19.camel@linux-z60t>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 11:11:04AM -0800, Kevin Lloyd wrote:
> From: Kevin Lloyd <linux@sierrawireless.com>
> 
> This patch is targeted for the 2.6.24-rc7 kernel.
> 
> The following improvements were made:
>  - Added new product support: MC5725, AC 880 U, MP 3G (UMTS & CDMA)
>  - Fixed control line issue where asserting DTR on ep5 would close ep2
>  - Added support for calc_num_ports (will help support future composite devices)
> 
> This also covers the devices added by j@twu.net and
> agilmore@wirelessbeehive.com since their patches were not committed to
> the 2.6.23-rc7 kernel.

Those device ids are already in my tree, as it was my understanding that
you would not be sending me patches for them :)

I'll split this patch up into something that updates the device ids and
then does all of the other changes.  The device ids can go into 2.6.24
(and -stable if I miss the merge window), but the other changes should
wait until 2.6.25.

Any objection to this?

thanks,

greg k-h
