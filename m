Return-Path: <linux-kernel-owner+w=401wt.eu-S1766763AbXEBTgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766763AbXEBTgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766771AbXEBTfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:35:48 -0400
Received: from mga05.intel.com ([192.55.52.89]:12131 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766769AbXEBTfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:35:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,481,1170662400"; 
   d="scan'208";a="240860762"
Subject: Regression with SLUB on Netperf and Volanomark
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: clameter@sgi.com
Cc: suresh.b.siddha@intel.com, yanmin.zhang@intel.com,
       peter.xihong.wang@intel.com, arjan.van.de.ven@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain
Organization: Intel
Date: Wed, 02 May 2007 11:43:29 -0700
Message-Id: <1178131409.23795.160.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

We tested SLUB on a 2 socket Clovertown (Core 2 cpu with 2 cores/socket)
and a 2 socket Woodcrest (Core2 cpu with 4 cores/socket).  

We found that for Netperf's TCP streaming tests in a loop back mode, the
TCP streaming performance is about 7% worse when SLUB is enabled on
2.6.21-rc7-mm1 kernel (x86_64).  This test have a lot of sk_buff
allocation/deallocation.

For Volanomark, the performance is 7% worse for Woodcrest and 12% worse
for Clovertown.

Regards,
Tim
