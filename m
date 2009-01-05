Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZAER2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZAER2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZAER2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:28:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48684 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZAER2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:28:12 -0500
Date: Mon, 5 Jan 2009 17:28:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [PATCH] fix --build-id breakage for sun3
Message-ID: <20090105172810.GQ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Counterpart of commit 08a3db94f2a36c28278922732bc281c1722ceb18 for
sun3 build.

Signet-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/kernel/vmlinux-sun3.lds |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index 8a4919e..d9368c0 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -33,6 +33,7 @@ SECTIONS
 	} :data
   /* End of data goes *here* so that freeing init code works properly. */
   _edata = .;
+  NOTES
 
   /* will be freed after init */
   . = ALIGN(PAGE_SIZE);	/* Init code and data */
-- 
1.5.6.5


