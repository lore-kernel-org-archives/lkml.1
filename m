Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYCLUOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYCLUOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYCLUOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:14:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:11460 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYCLUOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=GYRh2fAgDPK7MFivGzVNmavWemO0UN0b4uEWCkwBzrtKMszALty/DEaMMCrxbIr319i7Hp+xvHqyQ7FuFpM/D8U0Ud+7Npl9IUDbmLGI1Bl24LqWS5cihpIC+Nv/S932oIPF//aLRmpeu6PSAISmfz0GhrDgm4Oy9pRYX9F72Ys=
Date: Wed, 12 Mar 2008 23:14:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: parocessor.h - use PAGE_SIZE instead of numeric
	constant
Message-ID: <20080312201405.GA9591@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces numeric constant with an appropriate macro

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Index: linux-2.6.git/include/asm-x86/processor.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/processor.h	2008-02-20 19:14:57.000000000 +0300
+++ linux-2.6.git/include/asm-x86/processor.h	2008-03-12 23:10:02.000000000 +0300
@@ -786,7 +786,7 @@ extern unsigned long thread_saved_pc(str
 /*
  * User space process size. 47bits minus one guard page.
  */
-#define TASK_SIZE64	(0x800000000000UL - 4096)
+#define TASK_SIZE64	(0x800000000000UL - PAGE_SIZE)
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
