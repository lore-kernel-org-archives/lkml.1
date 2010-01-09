Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792Ab0AIS3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0AIS3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 13:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779Ab0AIS3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 13:29:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:49997 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab0AIS3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 13:29:35 -0500
Date: Sat, 9 Jan 2010 10:23:43 -0800
From: Greg KH <gregkh@suse.de>
To: Chandru <chandru@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ibmphp : read the length of ebda and map entire ebda
 region
Message-ID: <20100109182343.GA4695@suse.de>
References: <201001091712.25655.chandru@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001091712.25655.chandru@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 05:12:25PM +0530, Chandru wrote:
> ibmphp driver currently maps only 1KB of ebda memory area into kernel address 
> space during driver initialization. This causes kernel oops when the driver is 
> modprobe'd and it accesses memory area beyond 1KB within ebda segment. The first 
> byte of ebda segment actually stores the length of the ebda region in 
> Kilobytes. Hence make use of the length parameter and map the entire ebda 
> region.
> 
> 
> Signed-off-by: Chandru Siddalingappa <chandru@linux.vnet.ibm.com>
> ---
> 
>  drivers/pci/hotplug/ibmphp_ebda.c |   11 +++++++++--

Please use the scripts/get_maintainer.pl script to get the proper person
and mailing list to send this patch to (hint, it's not me.)

thanks,

greg k-h
