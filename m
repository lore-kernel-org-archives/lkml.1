Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbXKSPcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbXKSPcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbXKSPcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:32:13 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:25957 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbXKSPcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:32:12 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Adam Litke <agl@us.ibm.com>
Subject: Re: [PATCH] hugetlb: follow_hugetlb_page for write access
Date: Mon, 19 Nov 2007 16:25:00 +0100
User-Agent: KMail/1.8.2
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Ken Chen <kenchen@google.com>
References: <20071107195142.13505.49398.stgit@kernel>
In-Reply-To: <20071107195142.13505.49398.stgit@kernel>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711191625.00882.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007 20:51, Adam Litke wrote:
> 
> When calling get_user_pages(), a write flag is passed in by the caller to
> indicate if write access is required on the faulted-in pages.  Currently,
> follow_hugetlb_page() ignores this flag and always faults pages for
> read-only access.  This can cause data corruption because a device driver
> that calls get_user_pages() with write set will not expect COW faults to
> occur on the returned pages.
> 
> This patch passes the write flag down to follow_hugetlb_page() and makes
> sure hugetlb_fault() is called with the right write_access parameter.
> 
> Signed-off-by: Adam Litke <agl@us.ibm.com>
Apologize for this late response.
Tested on 2.6.23 with ehca and mthca. It works like a charm for me.
Thanks!
Nam

