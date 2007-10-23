Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbXJWIDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbXJWIDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXJWID3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:03:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:61216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXJWID0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:03:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,316,1188802800"; 
   d="scan'208";a="355636183"
Subject: [PATCH -v7 0/3] x86 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Oct 2007 16:06:05 +0800
Message-Id: <1193126765.23935.74.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 23 Oct 2007 08:03:23.0159 (UTC) FILETIME=[2EC71A70:01C8154B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set defines a 32-bit boot protocol for x86 platform, adds
an extensible boot parameter passing mechanism, export the boot
parameters via sysfs.

The patch set has been tested against kernel of git version
v2.6.23-6623-g55b70a0 (with Rusty's git tree pulled) on x86_64 and
i386.

This patch set is based on the proposal of Peter Anvin.


v7:

- Rebase on Rusty's git tree.
- Revise the 32-bit boot protocol document.

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
