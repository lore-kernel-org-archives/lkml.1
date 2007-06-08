Return-Path: <linux-kernel-owner+w=401wt.eu-S966619AbXFHACI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966619AbXFHACI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762685AbXFHABy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:01:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762575AbXFHABy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:01:54 -0400
Date: Thu, 7 Jun 2007 17:01:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: anil.s.keshavamurthy@intel.com
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 09/10] Iommu Gfx workaround
Message-Id: <20070607170132.3d0e2a2a.akpm@linux-foundation.org>
In-Reply-To: <20070606190043.060111000@askeshav-devel.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
	<20070606190043.060111000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 11:57:07 -0700
anil.s.keshavamurthy@intel.com wrote:

> +#ifdef CONFIG_DMAR_GFX_WA
> +	iommu_prepare_gfx_mapping();
> +#endif

Please do

#ifndef CONFIG_DMAR_GFX_WA
static inline void iommu_prepare_gfx_mapping(void)
{
}
#endif

in the head file instead (whole patchset)
