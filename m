Return-Path: <linux-kernel-owner+w=401wt.eu-S1764224AbZCYSsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764224AbZCYSsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764188AbZCYSrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:47:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:41541 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764179AbZCYSru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:47:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,420,1233561600"; 
   d="scan'208";a="442002704"
Message-Id: <20090325184548.012018000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 11:45:48 -0700
From: fenghua.yu@intel.com
To: mingo@elte.hu, dwmw2@infradead.org, amluto@gmail.com, kyle@redhat.com,
       mgross@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [patch 0/2] Intel IOMMU Suspend/Resume Support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current Intel IOMMU does not support suspend and resume. In S3 event, kernel
crashes when IOMMU is enabled. The attached patch set implements the suspend and
resume feature for Intel IOMMU. It hooks to kernel suspend and resume interface.
When suspend happens, it saves necessary hardware registers. When resume happens
it restores the registers and restarts IOMMU.

This patch set is applied to the tip tree.

-- 

