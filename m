Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZDUCo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZDUCo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 22:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZDUCor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 22:44:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43444 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZDUCoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 22:44:46 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 03/25] Do not check NUMA node ID when the caller knows the node is valid
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-4-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-4-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421114121.F11F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 11:44:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Callers of alloc_pages_node() can optionally specify -1 as a node to mean
> "allocate from the current node". However, a number of the callers in fast
> paths know for a fact their node is valid. To avoid a comparison and branch,
> this patch adds alloc_pages_exact_node() that only checks the nid with
> VM_BUG_ON(). Callers that know their node is valid are then converted.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

I think there still are convertable caller. (recently, caller increased a bit)
but it isn't important. anyway,

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



