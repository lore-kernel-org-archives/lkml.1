Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbZKLChy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbZKLChy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbZKLChy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:37:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:56177 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759989AbZKLChx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:37:53 -0500
Subject: Re: [stable][PATCH] PCIe hot-plug for Intel IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jbarnes@virtuousgeek.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, stable@kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091111152306.GA29256@linux-os.sc.intel.com>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
	 <1257807747.25961.852.camel@macbook.infradead.org>
	 <20091111152306.GA29256@linux-os.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 02:37:15 +0000
Message-ID: <1257993435.3907.86.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 07:23 -0800, Fenghua Yu wrote:
> To support PCIe hot plug in IOMMU, we register a notifier to respond to device
> change action.
> 
> When the notifier gets BUS_NOTIFY_UNBOUND_DRIVER, it removes the device from its
> DMAR domain.
> 
> A hot added device will be added into an IOMMU domain when it first does IOMMU
> op. So there is no need to add more code for hot add.
> 
> Without the patch, after a hot-remove, a hot-added device on the same slot will
> not work.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> 
> ---
> 
> The patch missed 2.6.32 release. Could it be in 2.6.32 stable?

Not strictly a regression, but it would make a lot of sense.

Fenghua, please could you test what's in
git://git.infradead.org/~dwmw2/iommu-2.6.32.git on IA64 before I send it
to Linus? There are a couple of other fixes for HP brain damage there.


-- 
dwmw2

