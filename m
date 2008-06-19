Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYFSLHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYFSLHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 07:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbYFSLGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 07:06:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014AbYFSLGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:06:33 -0400
Date: Thu, 19 Jun 2008 04:04:18 -0700
From: Greg KH <greg@kroah.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] jedec_probe: Fix SST 16-bit chip detection
Message-ID: <20080619110418.GB27196@kroah.com>
References: <20080619.163648.262833678.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619.163648.262833678.nemoto@toshiba-tops.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 04:36:48PM +0900, Atsushi Nemoto wrote:
> The unlock_addr rework in kernel 2.6.25 breaks 16-bit SST chips.  SST
> 39LF160 and SST 39VF1601 are both 16-bit only chip and new uaddr value
> is not correct for them.  Add MTD_UADDR_0xAAAA_0x5555 for those chips.
> Tested with SST 39VF1601 chip.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

In the future, if you want something to go into the stable tree, just
add:
	cc: stable <stable@kernel.org>
to the signed-off-by area of the patch and we will be automatically
notifed when it goes into Linus's tree and will then add it to the
-stable tree.

Otherwise it's a pain to try to track when a patch goes into mainline.

Can you notify us when this patch is accepted?

thanks,

greg k-h
