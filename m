Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZDXXY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZDXXY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 19:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZDXXYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 19:24:50 -0400
Received: from 8bytes.org ([88.198.83.132]:56852 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZDXXYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 19:24:50 -0400
Date: Sat, 25 Apr 2009 01:24:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Greg KH <gregkh@suse.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver/base: add BUS_NOTIFY_UNBOUND_DRIVER event
Message-ID: <20090424232447.GB12658@8bytes.org>
References: <1240577820-13783-1-git-send-email-joerg.roedel@amd.com> <20090424184425.GB20845@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424184425.GB20845@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 11:44:25AM -0700, Greg KH wrote:
> On Fri, Apr 24, 2009 at 02:57:00PM +0200, Joerg Roedel wrote:
> > This patch adds a new bus notifier event which is emitted _after_ a
> > device is removed from its driver. This event will be used by the
> > dma-api debug code to check if a driver has released all dma allocations
> > for that device.
> 
> Heh, I was wondering if people were going to need that.  I'll queue it
> up for 2.6.31, is that ok with you?  Do you have patches that depend on
> it?

2.6.31 is ok for me. I sent Ingo a patch to remove the broken feature
which uses the wrong event for 2.6.30. I can reintroduce the fixed
version for 2.6.31 too.
Other way may be to send this patch to 2.6.30 which makes a smaller fix
possible for dma-api debugging. But I am not sure if this new event
could go in after the merge window. So I choosed this way :)
For me, 2.6.31 for this patch is fine.

Thanks,

	Joerg
