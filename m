Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbYIVOQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbYIVOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYIVOQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:16:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:47255 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbYIVOQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:16:48 -0400
Date: Mon, 22 Sep 2008 23:16:25 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off
 instead of amd_iommu=off"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080922140749.GY24392@amd.com>
References: <20080922223457W.fujita.tomonori@lab.ntt.co.jp>
	<20080922140749.GY24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080922231619X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 16:07:49 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Mon, Sep 22, 2008 at 10:35:08PM +0900, FUJITA Tomonori wrote:
> > This is against tip/x86/iommu.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off"
> > 
> > This reverts:
> > 
> > commit 8b14518fadd9d5915827d86d5c10e602fedf042e
> > Author: Joerg Roedel <joerg.roedel@amd.com>
> > Date:   Thu Jul 3 19:35:09 2008 +0200
> > 
> >     x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off
> > 
> >     This patch removes the amd_iommu=off kernel parameter and honors the generic
> > 
> >     iommu=off parameter for the same purpose.
> > 
> > 
> > The above commit is wrong.
> 
> It isn't. The user normally don't care about the type of IOMMU in the
> system. So disabling it with iommu=off is the right way. To achieve what
> you want its better to add iommu=gart and iommu=amd to the option
> parser. This will be consistent with Calgary and SWIOTLB too.

I'm not talking about what the best way to disable IOMMUs for
users. I'm talking about how the current code works. It's a different
topic. If you want to fix this, that's fine.

I just pointed out:

- You think that iommu=off and amd_iommu=off worked in the same way,
but they didn't.

- This commit removed the useful feature.



