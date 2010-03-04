Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab0CDCaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:30:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:6229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab0CDCar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:30:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,577,1262592000"; 
   d="scan'208";a="545890414"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH -v2 0/2] ACPI, APEI, use general HEST table parsing in AER firmware_first setup
Date: Thu,  4 Mar 2010 10:30:32 +0800
Message-Id: <1267669834-30630-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog:

v2:

- Setup firmware_first for every PCIE end point instead of just root point.

- Wrap firmware accessing in a function instead of raw hardware, because HEST
  parsing involved.
