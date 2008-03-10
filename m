Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYCJQLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYCJQLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYCJQKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:10:53 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:58226 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbYCJQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:10:52 -0400
Date: Mon, 10 Mar 2008 19:10:49 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       akpm@linux-foundation.org, rth@twiddle.net, tomof@acm.org
Subject: Re: [PATCH -mm] alpha: use iommu_is_span_boundary helper function
Message-ID: <20080310161049.GA10759@jurassic.park.msu.ru>
References: <20080310231010H.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310231010H.tomof@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 11:34:53PM +0900, FUJITA Tomonori wrote:
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH -mm] alpha: use iommu_is_span_boundary helper function
> 
> iommu_is_span_boundary in lib/iommu-helper.c was exported for PARISC
> IOMMUs (commit 3715863aa142c4f4c5208f5f3e5e9bac06006d2f). Alpha's
> IOMMU can use it.
> 
> This removes the check on the boundary size alignment because
> iommu_is_span_boundary does.

Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.
