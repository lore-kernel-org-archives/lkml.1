Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbZJUNtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbZJUNtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 09:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZJUNtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 09:49:13 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:6370 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZJUNtM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-lchiquitto@novell.com;3:2>);
	Wed, 21 Oct 2009 09:49:12 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2009 09:49:12 EDT
Message-Id: <4ADEF08D020000860004410B@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 21 Oct 2009 07:29:17 -0600
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
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks for refreshing and resubmitting this. I just received feedback
confirming that the patch resolves the problem.

Kind regards,
Leonardo

