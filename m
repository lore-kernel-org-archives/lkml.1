Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYKDWVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYKDWVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYKDWU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:20:56 -0500
Received: from kroah.org ([198.145.64.141]:36899 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751888AbYKDWU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:20:56 -0500
Date: Tue, 4 Nov 2008 14:07:43 -0800
From: Greg KH <greg@kroah.com>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: stable@kernel.org, linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [stable] 16G related patches for stable kernel 2.6.27
Message-ID: <20081104220743.GE3516@kroah.com>
References: <4908CE18.3030205@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4908CE18.3030205@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 03:56:56PM -0500, Jon Tollefson wrote:
> Please consider the following patches for the 2.6.27 stable tree.
> 
> The first two allow a powerpc machine with more then 2 numa nodes
> to boot when 16G pages are enabled.  The third one allows a powerpc
> machine to boot if using 16G pages and the mem= boot param.
> 
> thanks,
> Jon
> 
> 
> powerpc: Reserve in bootmem lmb reserved regions that cross NUMA nodes
>     commit 8f64e1f2d1e09267ac926e15090fd505c1c0cbcb
> powerpc/numa: Make memory reserve code more robust
>     commit e81703724a966120ace6504c993bda9e084cbf3e
> powerpc: Don't use a 16G page if beyond mem= limits
>     commit 4792adbac9eb41cea77a45ab76258ea10d411173

I've queued up all of these.

thanks,

greg k-h
