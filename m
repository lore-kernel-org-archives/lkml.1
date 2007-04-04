Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbXDDR0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbXDDR0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXDDR0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:26:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXDDR0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:26:52 -0400
Date: Wed, 4 Apr 2007 13:25:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Subject: [PATCH] allow vmsplice to work in 32-bit mode on ppc64
Message-ID: <20070404172519.GZ11029@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial change to pass vmsplice arguments through the compat layer on
pp64.

Signed-off-by: Don Zickus <dzickus@redhat.com>


diff --git a/include/asm-powerpc/systbl.h b/include/asm-powerpc/systbl.h
index 8d853c5..0b00068 100644
--- a/include/asm-powerpc/systbl.h
+++ b/include/asm-powerpc/systbl.h
@@ -288,7 +288,7 @@ COMPAT_SYS(ppoll)
 SYSCALL_SPU(unshare)
 SYSCALL_SPU(splice)
 SYSCALL_SPU(tee)
-SYSCALL_SPU(vmsplice)
+COMPAT_SYS_SPU(vmsplice)
 COMPAT_SYS_SPU(openat)
 SYSCALL_SPU(mkdirat)
 SYSCALL_SPU(mknodat)
