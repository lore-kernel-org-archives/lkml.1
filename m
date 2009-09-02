Return-Path: <linux-kernel-owner+w=401wt.eu-S1751043AbZIBECj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbZIBECj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 00:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbZIBECi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 00:02:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:38152 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZIBECi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 00:02:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="183082192"
Message-Id: <20090902034125.718886329@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 02 Sep 2009 11:41:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Christoph Lameter <cl@linux-foundation.org>
cc: "Wu, Fengguang" <fengguang.wu@intel.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Chris Wright <chrisw@redhat.com>
CC: "Huang, Ying" <ying.huang@intel.com>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Josh Triplett <josh@joshtriplett.org>, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
cc: linux-mm@kvack.org
Subject: [RFC][PATCH 0/4] move tools in Documentation/vm/ to tools/vm/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

3 useful tools (which are more than code examples) in Documentation/vm/
	- page-types
	- slabinfo
	- slqbinfo
are moved to tools/vm/, and page-types is updated to support two new flags.

The tools can be compiled together by

	make tools/vm/

Note that checkpatch complains some style problems on slabinfo.c/slqbinfo.c,
which are leaved as is.

Thanks,
Fengguang
-- 

