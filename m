Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZDNK3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZDNK3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZDNK3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:29:03 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:36985 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZDNK3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:29:01 -0400
Date: Tue, 14 Apr 2009 13:26:45 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, alexisb@us.ibm.com
Subject: Re: [PATCH] calgary: remove IOMMU_DEBUG
Message-ID: <20090414102645.GD13863@il.ibm.com>
References: <20090414120827G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414120827G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 12:12:29PM +0900, FUJITA Tomonori wrote:
> CONFIG_IOMMU_DEBUG has depends on CONFIG_GART_IOMMU:
> 
> config IOMMU_DEBUG
> 	bool "Enable IOMMU debugging"
> 	depends on GART_IOMMU && DEBUG_KERNEL
> 	depends on X86_64
> 
> So it's not useful to have CONFIG_IOMMU_DEBUG in Calgary IOMMU code,
> which does the extra checking of the bitmap space management.
> 
> And Calgary uses the iommu helper for the bitmap space management now
> so it would be better to have the extra checking feature in the iommu
> helper rather than Calgary code (if necessary).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
-- 
Muli Ben-Yehuda | muli@il.ibm.com | +972-4-8281080
Manager, Virtualization and Systems Architecture
Master Inventor, IBM Haifa Research Laboratory

SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
