Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZDXX7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZDXX7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 19:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZDXX7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 19:59:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbZDXX7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 19:59:30 -0400
Date: Fri, 24 Apr 2009 16:44:32 -0700
From: Greg KH <gregkh@suse.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver/base: add BUS_NOTIFY_UNBOUND_DRIVER event
Message-ID: <20090424234432.GA6054@suse.de>
References: <1240577820-13783-1-git-send-email-joerg.roedel@amd.com> <20090424184425.GB20845@suse.de> <20090424232447.GB12658@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424232447.GB12658@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 01:24:47AM +0200, Joerg Roedel wrote:
> On Fri, Apr 24, 2009 at 11:44:25AM -0700, Greg KH wrote:
> > On Fri, Apr 24, 2009 at 02:57:00PM +0200, Joerg Roedel wrote:
> > > This patch adds a new bus notifier event which is emitted _after_ a
> > > device is removed from its driver. This event will be used by the
> > > dma-api debug code to check if a driver has released all dma allocations
> > > for that device.
> > 
> > Heh, I was wondering if people were going to need that.  I'll queue it
> > up for 2.6.31, is that ok with you?  Do you have patches that depend on
> > it?
> 
> 2.6.31 is ok for me. I sent Ingo a patch to remove the broken feature
> which uses the wrong event for 2.6.30. I can reintroduce the fixed
> version for 2.6.31 too.
> Other way may be to send this patch to 2.6.30 which makes a smaller fix
> possible for dma-api debugging. But I am not sure if this new event
> could go in after the merge window. So I choosed this way :)
> For me, 2.6.31 for this patch is fine.

Great, it will go in for 2.6.31 then.

thanks,

greg k-h
