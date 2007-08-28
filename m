Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbXH1WmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbXH1WmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 18:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXH1Wly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 18:41:54 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35296 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbXH1Wlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 18:41:53 -0400
Subject: Re: [PATCH] Fix find_next_best_node (Re: [BUG] 2.6.23-rc3-mm1
	Kernel panic - not syncing: DMA: Memory would be corrupted)
From: Adam Litke <agl@us.ibm.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       "Luck, Tony" <tony.luck@intel.com>, Jeremy Higdon <jeremy@sgi.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-ia64@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org
In-Reply-To: <20070824153945.3C75.Y-GOTO@jp.fujitsu.com>
References: <617E1C2C70743745A92448908E030B2A023EB020@scsmsx411.amr.corp.intel.com>
	 <20070823142133.9359a1ce.akpm@linux-foundation.org>
	 <20070824153945.3C75.Y-GOTO@jp.fujitsu.com>
Content-Type: text/plain
Organization: IBM
Date: Tue, 28 Aug 2007 17:41:40 -0500
Message-Id: <1188340900.15336.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 15:53 +0900, Yasunori Goto wrote:
> I found find_next_best_node() was wrong.
> I confirmed boot up by the following patch.
> Mel-san, Kamalesh-san, could you try this?

FYI: This patch also allows the alloc-instantiate-race testcase in
libhugetlbfs to pass again :)

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

