Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbZCSV4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbZCSV4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758804AbZCSVza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:55:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:21788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbZCSVz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,391,1233561600"; 
   d="scan'208";a="395968563"
Message-Id: <20090319215112.636641000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 14:51:12 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com
Cc: arjan@infradead.org, eric@anholt.net, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 0/3] x86, CPA: Introduce new APIs set_pages_array[uc|wb]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AGP is moving over to using struct page pointer array in place of
virtual address array. So, it needs a equivalent of set_memory_array_[uc|wb]
which will operate on struct page pointer array instead.

The patch series adds two new interfaces in x86 CPA code,
set_pages_array_uc
set_pages_array_wb

which will change the memory type of a set of pages referred to by struct page
pointers, which need not be contiguous.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

-- 

