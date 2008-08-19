Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYHSTkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYHSTkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYHSTkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:40:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:2749 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYHSTkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qG/NbF6LFey2RpO3+GKiET0QoT8ER7TNpo8kAQ+66Oz8GllVahPXe9yLSqIqLPNl7F
         pH/WZ0UvVA3nkxi9xt1MHVWnp/2pIMqgnW83pvqJqx6DwxRbSRnB+dLpLJUQxOMoKrEp
         5ujXEsctBzr+UewSoKxXgaRjZBGQQytMCXxyM=
Message-ID: <86802c440808191240t66ee67c1ub173c462025b6929@mail.gmail.com>
Date: Tue, 19 Aug 2008 12:40:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [patch] fix intr-remap with dyn_array/nr_irqs changes
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       x86@kernel.org
In-Reply-To: <20080819185441.GC1152@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080819185441.GC1152@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:54 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> I didn't find time to closely review the dyn_array/nr_irqs changes. But
> the appended patch is needed to fix the broken intr-remapping support on
> x86/tip
>
> And also, I don't see any locks used in to_irq_desc_with_new(). How are
> we handling the concurrent usage scenarios. And also, this code can use
> some cleanups (like the names, to_irq_desc_with_new()?) etc.
>
> thanks,
> suresh
> ---
>
> In irq_2_iommu_with_new() and set_irte_irq(), irq_desc or
> irq_2_iommu pointers may not be allocated. So use the routines which
> will allocate them if they are not already allocated.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

i'm trying to rebase sparseirq to tip/x86/core.

will address your concern about lock after that.

Thanks

YH
