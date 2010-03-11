Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0CKCSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:18:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:15543 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab0CKCSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:18:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,617,1262592000"; 
   d="scan'208";a="603273681"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH -v2 0/2] ACPI, APEI, use general HEST table parsing in AER firmware_first setup (resend)
Date: Thu, 11 Mar 2010 10:14:56 +0800
Message-Id: <1268273698-21940-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog:

v2:

- Setup firmware_first for every PCIE end point instead of just root point.

- Wrap firmware accessing in a function instead of raw hardware, because HEST
 parsing involved.
