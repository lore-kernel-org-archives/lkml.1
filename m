Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZLOKzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZLOKzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbZLOKzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:55:20 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:11360 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbZLOKzT convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-lchiquitto@novell.com;3:2>);
	Tue, 15 Dec 2009 05:55:19 -0500
X-Greylist: delayed 1203 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2009 05:55:19 EST
Message-Id: <4B274A9A020000860004B505@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 15 Dec 2009 03:36:42 -0700
From: "Leonardo Chiquitto" <lchiquitto@novell.com>
To: <tony.luck@intel.com>, "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       <linux-ia64@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ia64: fix SBA IOMMU to handle allocation failure
	 properly
References: <20091018140631K.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091018140631K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10/18/2009 at 03:07 AM, in message
<20091018140631K.fujita.tomonori@lab.ntt.co.jp>, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote: 
> This is an updated patch of the patch that I've posted one year
> ago. Shehjar reported the problem and confirmed that the patch fixes
> it:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0811.0/01562.html
> 
> Leonardo told me that he hit the same problem and confirmed that the
> patch fixes it.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] ia64: fix SBA IOMMU to handle allocation failure properly
> 
> It's possible that SBA IOMMU might fail to find I/O space under heavy
> I/Os. SBA IOMMU panics on allocation failure but it shouldn't; drivers
> can handle the failure. The majority of other IOMMU drivers don't
> panic on allocation failure.
> 
> This patch fixes SBA IOMMU path to handle allocation failure properly.

Hello,

Please, any chance to have this patch committed to 2.6.33?

Thanks,
Leonardo

