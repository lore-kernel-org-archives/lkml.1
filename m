Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYK1KOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYK1KOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbYK1KOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:14:24 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:44012 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYK1KOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:14:23 -0500
X-Greylist: delayed 2078 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2008 05:14:23 EST
To: joerg.roedel@amd.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, weidong.han@intel.com,
       mingo@redhat.com, avi@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1227800454-9555-4-git-send-email-joerg.roedel@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
	<1227800454-9555-4-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081128184041N.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 28 Nov 2008 18:40:41 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008 16:40:48 +0100
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/base/iommu.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 94 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/base/iommu.c
> 
> diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
> new file mode 100644
> index 0000000..7250b9c
> --- /dev/null
> +++ b/drivers/base/iommu.c

Hmm, why is this at drivers/base/? Anyone except for kvm could use
this? If so, under virt/ is more appropriate?

The majority of the names (include/linux/iommu.h, iommu.c, iommu_ops,
etc) looks too generic? We already have lots of similar things
(e.g. arch/{x86,ia64}/asm/iommu.h, several archs' iommu.c, etc). Such
names are expected to be used by all the IOMMUs.
