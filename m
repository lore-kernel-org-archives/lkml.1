Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbZFKS3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbZFKS3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbZFKS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:28:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:36114 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984AbZFKS25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:28:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="153266304"
Date: Thu, 11 Jun 2009 11:28:18 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Message-ID: <20090611112818.149b568e@jbarnes-g45>
In-Reply-To: <20090507082841.GA31751@redhat.com>
References: <20090507082841.GA31751@redhat.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 11:28:41 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> pci_enable_msix currently returns -EINVAL if you ask
> for more vectors than supported by the device, which would
> typically cause fallback to regular interrupts.
> 
> It's better to return the table size, making the driver retry
> MSI-X with less vectors.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Hi Jesse,
> This came up when I was adding MSI-X support to virtio pci driver,
> which does not know the exact table size upfront.
> Could you consider this patch for 2.6.31 please?

Applied this one to my linux-next branch; hopefully Rusty won't mind
too much. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
