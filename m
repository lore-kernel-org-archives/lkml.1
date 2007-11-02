Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbXKBCq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbXKBCq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXKBCqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:46:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:33473 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbXKBCqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:46:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,361,1188802800"; 
   d="scan'208";a="310022226"
Subject: [PATCH 0/2 -v3] x86_64 EFI boot support
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Nov 2007 10:49:35 +0800
Message-Id: <1193971775.11724.30.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 02 Nov 2007 02:46:26.0969 (UTC) FILETIME=[90604890:01C81CFA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following sets of patches add EFI/UEFI (Unified Extensible Firmware
Interface) boot support to x86_64 architecture.

The patches have been tested against 2.6.24-rc1 kernel on Intel
platforms with EFI1.10 and UEFI2.0 firmware. With this set of patches
applied, the 64bit and 32bit x86 kernel can be booted on x86_64
machine with UEFI64 firmware.

Because the EFI memory map is converted to E820 map in bootloader, now
the only needed code for booting Linux kernel on x86_64 UEFI platform
is the framebuffer driver.

UEFI specification can be found here: http://www.uefi.org

For booting the UEFI x86_64 enabled kernel, the machine with EFI/UEFI
firmware and the support of bootloader is required. Detailed usage
guide can be found in Documentation/x86_64/uefi.txt, which is added in
the patch: EFI boot document


v3:

- The VIDEO_TYPE_EFI is changed to 0x70 to group VIDEO_TYPE_<XX> better.

v2:

- The include files of efifb.c is cleaned up.
- Make CONFIG_FB_EFI not depend on CONFIG_EFI.


Best Regards,
Huang Ying
