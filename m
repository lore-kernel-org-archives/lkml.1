Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbYCaXgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbYCaXgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 19:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYCaXgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 19:36:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52795 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYCaXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:36:15 -0400
Date: Tue, 01 Apr 2008 08:28:12 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: ebmunson@us.ibm.com
Subject: Re: [PATCH] hugetlb: vmstat events for huge page allocations
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@osdl.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, agl@us.ibm.com
In-Reply-To: <1206978548.8042.7.camel@grover.beaverton.ibm.com>
References: <1206978548.8042.7.camel@grover.beaverton.ibm.com>
Message-Id: <20080401082435.3A47.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Allocating huge pages directly from the buddy allocator is not guaranteed
> to succeed.  Success depends on several factors (such as the amount of
> physical memory available and the level of fragmentation).  With the
> addition of dynamic hugetlb pool resizing, allocations can occur much more
> frequently.  For these reasons it is desirable to keep track of huge page
> allocation successes and failures.
> 
> Add two new vmstat entries to track huge page allocations that succeed and
> fail.  The presence of the two entries is contingent upon
> CONFIG_HUGETLB_PAGE being enabled.

In generaly, I like this patch.

Have you seen Andi Kleen's "GB pages hugetlb support" series?
it contain multiple size hugepage support.
if it is merged, Is your patch caused any effect?



