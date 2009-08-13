Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZHMIXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZHMIXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZHMIXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:23:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:42735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZHMIXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:23:30 -0400
Subject: Re: [RFC patch] clean up swiotlb check in intel_iommu_init
From: David Woodhouse <dwmw2@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <3877989d0908122011n27589ff8wfc6d6b50912496c6@mail.gmail.com>
References: <3877989d0908122011n27589ff8wfc6d6b50912496c6@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 09:23:21 +0100
Message-Id: <1250151801.29180.192.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 11:11 +0800, Luming Yu wrote:
> 
> Since swiotlb is an fall back option that might have
> initialized. We don't need to stop intel_iommu_init
> because of swiotlb..
> 
> Please review. If make sense, please apply.

It doesn't apply to the iommu-2.6.git tree.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

