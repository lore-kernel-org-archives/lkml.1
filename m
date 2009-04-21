Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZDUF7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZDUF7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZDUF7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:59:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38949 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZDUF7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:59:24 -0400
Message-ID: <49ED5FC6.4010007@cs.helsinki.fi>
Date: Tue, 21 Apr 2009 08:55:18 +0300
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
Subject: Re: [PATCH 01/25] Replace __alloc_pages_internal() with __alloc_pages_nodemask()
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-2-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1240266011-11140-2-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> __alloc_pages_internal is the core page allocator function but
> essentially it is an alias of __alloc_pages_nodemask. Naming a publicly
> available and exported function "internal" is also a big ugly. This
> patch renames __alloc_pages_internal() to __alloc_pages_nodemask() and
> deletes the old nodemask function.
> 
> Warning - This patch renames an exported symbol. No kernel driver is
> affected by external drivers calling __alloc_pages_internal() should
> change the call to __alloc_pages_nodemask() without any alteration of
> parameters.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
