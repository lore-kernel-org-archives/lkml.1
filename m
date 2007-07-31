Return-Path: <linux-kernel-owner+w=401wt.eu-S967386AbXGaDNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967386AbXGaDNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965505AbXGaDNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:13:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:6910 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759525AbXGaDNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:13:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,201,1183359600"; 
   d="scan'208";a="111633733"
Subject: [PATCH 0/5] x86_64 EFI support -v3
From: "Huang, Ying" <ying.huang@intel.com>
To: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 11:12:49 +0800
Message-Id: <1185851569.23149.25.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 03:13:00.0385 (UTC) FILETIME=[B34BC510:01C7D320]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following sets of patches add EFI/UEFI (Unified Extensible Firmware
Interface) support to x86_64 architecture. The patches have been
tested against 2.6.23-rc1 kernel on Intel platforms with EFI1.10 and
UEFI2.0 firmware.

UEFI specification can be found here: http://www.uefi.org

For booting the UEFI x86_64 enabled kernel, the machine with EFI/UEFI
firmware and the support of bootloader is required. Detailed usage
guide can be found in Documentation/x86_64/uefi.txt, which is added in
the patch: efi-doc.patch.

Issues _not_ addressed (per feedback from Eric Biederman)

- Virtual mode support is still retained in this patch. There is at
  least one EFI call is fast path: efi_set_rtc_mmss, which must
  complete as soon as possible.

- The variable efi_enabled is used throughout across architecutres if
 CONFIG_EFI option is enabled. The i386 code also uses this variable.
 This is something that can be revisited with code consolidation
 across architectures.

Looking forward to your comments,

Best Regards,
Huang Ying
