Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbYE0TEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbYE0TEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbYE0TDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:03:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:42912 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbYE0TDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:03:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=LuROYNfCUJsOjWBpMFCNkeS5/WpXpgyDgNHIlphmujmPUGoNlbl0IzCM867+d8VlyAhqjdkEC6LERqHacLAEd7GOGRGu7YLXfBvu3ApKSbwSjY60TdGuJDvEImenfc3qN2cxlqxbhWgbXoaxpP6iRNOIXqnW5dNhNQ2xjrWcrLw=
Date: Tue, 27 May 2008 21:03:46 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix incomplete include guard
Message-ID: <20080527190346.GA16422@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems that suspend_32.h and xor_32.h are missing include guards too,
but I'm not touching those since I don't know if that's intended or not
:-)

Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 27 May 2008 20:50:42 +0200
Subject: [PATCH] x86: fix incomplete include guard

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-x86/seccomp_32.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/seccomp_32.h b/include/asm-x86/seccomp_32.h
index 18da19e..36e71c5 100644
--- a/include/asm-x86/seccomp_32.h
+++ b/include/asm-x86/seccomp_32.h
@@ -1,4 +1,5 @@
 #ifndef _ASM_SECCOMP_H
+#define _ASM_SECCOMP_H
 
 #include <linux/thread_info.h>
 
-- 
1.5.4.1

