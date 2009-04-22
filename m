Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbZDVAf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbZDVAf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZDVAfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:35:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33056 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZDVAfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:35:47 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 22/25] Update NR_FREE_PAGES only as necessary
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
In-Reply-To: <1240266011-11140-23-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-23-git-send-email-mel@csn.ul.ie>
Message-Id: <20090422093506.6274.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 22 Apr 2009 09:35:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When pages are being freed to the buddy allocator, the zone
> NR_FREE_PAGES counter must be updated. In the case of bulk per-cpu page
> freeing, it's updated once per page. This retouches cache lines more
> than necessary. Update the counters one per per-cpu bulk free.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




