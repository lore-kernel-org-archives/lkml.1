Return-Path: <linux-kernel-owner+w=401wt.eu-S1763627AbZFKXa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763627AbZFKXa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbZFKXau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:30:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758212AbZFKXau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:30:50 -0400
Date: Thu, 11 Jun 2009 16:30:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com,
       cl@linux-foundation.org, fengguang.wu@intel.com, linuxram@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring
 behaviour more in line with expectations V3
Message-Id: <20090611163006.e985639f.akpm@linux-foundation.org>
In-Reply-To: <1244717273-15176-1-git-send-email-mel@csn.ul.ie>
References: <1244717273-15176-1-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 11:47:50 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> The big change with this release is that the patch reintroducing
> zone_reclaim_interval has been dropped as Ram reports the malloc() stalls
> have been resolved. If this bug occurs again, the counter will be there to
> help us identify the situation.

What is the exact relationship between this work and the somewhat
mangled "[PATCH for mmotm 0/5] introduce swap-backed-file-mapped count
and fix
vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch"
series?

That five-patch series had me thinking that it was time to drop 

vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
vmscan-drop-pf_swapwrite-from-zone_reclaim.patch
vmscan-zone_reclaim-use-may_swap.patch

(they can be removed cleanly, but I haven't tried compiling the result)

but your series is based on those.

We have 142 MM patches queued, and we need to merge next week.
