Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbXJXJay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbXJXJay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbXJXJaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:30:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:49969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbXJXJaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:30:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,323,1188802800"; 
   d="scan'208";a="304503162"
Subject: [PATCH 0/2 -v2 resend] x86_64 EFI boot support
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@pol.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Oct 2007 17:32:22 +0800
Message-Id: <1193218342.23935.147.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 24 Oct 2007 09:29:37.0099 (UTC) FILETIME=[651971B0:01C81620]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set has been dropped because the 32-bit boot protocol is
not ready. Now, the 32-bit boot protocol has been merged, so I resend
this patch set.

Can this patch set and 32-bit boot protocol document patch catch up
with the merge window of 2.6.24?


Following sets of patches add EFI/UEFI (Unified Extensible Firmware
Interface) boot support to x86_64 architecture.

The patches have been tested against 2.6.24-rc1 kernel on Intel
platforms with EFI1.10 and UEFI2.0 firmware. With this set of patches
applied, the 64 bit and 32 bit x86 kernel can be booted on x86_64
machine with UEFI64 firmware.

Because the EFI memory map is converted to E820 map in bootloader, now
the only needed code for booting Linux kernel on x86_64 UEFI platform
is the framebuffer driver.

UEFI specification can be found here: http://www.uefi.org

For booting the UEFI x86_64 enabled kernel, the machine with EFI/UEFI
firmware and the support of bootloader is required. Detailed usage
guide can be found in Documentation/x86_64/uefi.txt, which is added in
the patch: EFI boot document


v2:

- The include files of efifb.c is cleaned up.
- Make CONFIG_FB_EFI not depend on CONFIG_EFI.


Best Regards,
Huang Ying
