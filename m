Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbXJVHSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbXJVHSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbXJVHRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:17:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:3675 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXJVHRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:17:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,309,1188802800"; 
   d="scan'208";a="303143721"
Subject: [PATCH -v6 0/3] x86 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Oct 2007 15:16:48 +0800
Message-Id: <1193037408.23935.21.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 22 Oct 2007 07:14:09.0059 (UTC) FILETIME=[23957730:01C8147B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset defines a 32-bit boot protocol for x86 platform,
adds an extensible boot parameter passing mechanism, export the boot
parameters via sysfs.

The patchset has been tested against kernel of git version
v2.6.23-6623-g55b70a0 on x86_64 and i386.

This patchset is based on the proposal of Peter Anvin.


v6:

- The linked list of setup_data is copied to memory area right after
  the kernel _end during early kernel bootstrap to solve the issue
  that where the safe place is to place linked list of setup_data.

v5:

- Use bt_ioremap/bt_iounmap in copy_setup_data.

v4:

- Reserve setup_data and boot parameters for accessing during
  runtime.
- Export boot parameters via sysfs.

v3:

- Move hd0_info and hd1_info back to zero page for compatibility.

v2:

- Increase the boot protocol version number
- Check version number before parsing setup data.
- Revise zero page description according to the source code and move
  them to zero-page.txt.


Best Regards,
Huang Ying
