Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZDUGAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZDUGAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZDUGAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:00:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38949 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZDUGAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:00:05 -0400
Message-ID: <49ED5FEE.1060505@cs.helsinki.fi>
Date: Tue, 21 Apr 2009 08:55:58 +0300
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
Subject: Re: [PATCH 02/25] Do not sanity check order in the fast path
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-3-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1240266011-11140-3-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> No user of the allocator API should be passing in an order >= MAX_ORDER
> but we check for it on each and every allocation. Delete this check and
> make it a VM_BUG_ON check further down the call path.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
