Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbZEEMgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbZEEMgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 08:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZEEMgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 08:36:09 -0400
Received: from cmpxchg.org ([85.214.51.133]:54975 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbZEEMgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 08:36:09 -0400
Date: Tue, 5 May 2009 14:33:50 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmscan: ZVC updates in shrink_active_list() can be done once
Message-ID: <20090505123350.GA19060@cmpxchg.org>
References: <20090504234455.GA6324@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504234455.GA6324@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 07:44:55AM +0800, Wu Fengguang wrote:
> This effectively lifts the unit of nr_inactive_* and pgdeactivate updates
> from PAGEVEC_SIZE=14 to SWAP_CLUSTER_MAX=32.

For __zone_reclaim() it will be >= SWAP_CLUSTER_MAX, depending on the
allocation order.

	Hannes
