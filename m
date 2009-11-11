Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbZKKV1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbZKKV1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759288AbZKKV1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:27:04 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56809 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283AbZKKV1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:27:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SJOzK1PnrxmL0Hq9c3Y67b0WwsB4UDf6QhU5dxa57mSWfuuPConkl7kNYIY43AJcsn
         nnYQtspmEiBBe99T7ADMZICoAt2HNtdo5jd1ZQSE6eL3wyWGMhxb9VLFxhxgcKeMoUMc
         ckvDouxCqoWziTGN70L47BlEEEHobPBVbGHdU=
MIME-Version: 1.0
In-Reply-To: <20091111152306.GA29256@linux-os.sc.intel.com>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
	 <1257807747.25961.852.camel@macbook.infradead.org>
	 <20091111152306.GA29256@linux-os.sc.intel.com>
Date: Wed, 11 Nov 2009 13:27:07 -0800
Message-ID: <86802c440911111327o49bb2b09xc8ab801ce281d04@mail.gmail.com>
Subject: Re: [stable][PATCH] PCIe hot-plug for Intel IOMMU
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       jbarnes@virtuousgeek.org, stable@kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 7:23 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
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

Tested-by: Yinghai Lu <yinghai@kernel.org>

>
> ---
>
> The patch missed 2.6.32 release. Could it be in 2.6.32 stable?

Jesse,
can you push to Linus?

looks like David is too busy.

YH
