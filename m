Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935605Ab0COG6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 02:58:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:23847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934800Ab0COG6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,641,1262592000"; 
   d="scan'208";a="604418756"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       ying.huang@intel.com
Subject: [PATCH -v3 0/2] ACPI, APEI, use general HEST tabling parsing in AER firmware_first setup
Date: Mon, 15 Mar 2010 14:57:39 +0800
Message-Id: <1268636261-31554-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog:

v3:

- Move pcie_aer_get_firmware_first into aerdrv_acpi.c, and make
  aer_set_firmware_first static in aerdrv_acpi.c. This makes external
  interface simple and clear.

v2:

- Setup firmware_first for every PCIE end point instead of just root point.

- Wrap firmware_first accessing in a function, because HEST parsing involved.
