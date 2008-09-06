Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbYIFMTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbYIFMTC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbYIFMSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:18:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:58230 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYIFMSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:18:52 -0400
Date: Sat, 6 Sep 2008 21:18:36 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: fix nommu_alloc_coherent allocation with NULL
 device argument
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080905104049.GY3189@amd.com>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080905104049.GY3189@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080906211558L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 12:40:49 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> I agree with this patch in principle. It fixes the problem. But I think
> we should evaluate if we can change the dma_mask of the fallback_dev to
> 24 bit.

That's fine by me if someone who wrote the current code say that the
change is safe (though I think it's safe).
