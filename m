Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbXKLBmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbXKLBmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 20:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXKLBmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 20:42:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:6149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbXKLBmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 20:42:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,402,1188802800"; 
   d="scan'208";a="232595634"
Subject: Could you please merge the x86_64 EFI boot support patchset?
From: "Huang, Ying" <ying.huang@intel.com>
To: torvalds@linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 12 Nov 2007 09:45:50 +0800
Message-Id: <1194831950.17223.44.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 12 Nov 2007 01:42:16.0855 (UTC) FILETIME=[41A90270:01C824CD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Could you please merge the following patchset:

[PATCH 0/2 -v3] x86_64 EFI boot support
[PATCH 1/2 -v3] x86_64 EFI boot support: EFI frame buffer driver
[PATCH 2/2 -v3] x86_64 EFI boot support: EFI boot document

The patchset has been in -mm tree from 2.6.23-rc2-mm2 on. Andrew Moton
had suggested it to be merged into 2.6.24 during early merge window of
2.6.24. It was not merged because the 32-bit boot protocol had not been
done at that time.

Now, the 32-bit boot protocol has been merged into 2.6.24. And this
patch has been in x86 patch queue.

I know that it is a little late for this patchset to be merged into
2.6.24. But this patchset is very simple, just adds a framebuffer
driver, so it is impossible for this patchset to break anything. And
this patchset will be helpful for people have machine with UEFI 64
firmware instead of legacy BIOS.

Best Regards,
Huang Ying
