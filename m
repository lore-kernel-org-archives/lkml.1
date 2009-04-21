Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZDUGE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZDUGE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbZDUGET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:04:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51895 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZDUGET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:04:19 -0400
Message-ID: <49ED60E9.4030005@cs.helsinki.fi>
Date: Tue, 21 Apr 2009 09:00:09 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 03/25] Do not check NUMA node ID when the caller knows
 the node is valid
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-4-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1240266011-11140-4-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> Callers of alloc_pages_node() can optionally specify -1 as a node to mean
> "allocate from the current node". However, a number of the callers in fast
> paths know for a fact their node is valid. To avoid a comparison and branch,
> this patch adds alloc_pages_exact_node() that only checks the nid with
> VM_BUG_ON(). Callers that know their node is valid are then converted.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
