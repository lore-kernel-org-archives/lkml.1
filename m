Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113Ab0ALKhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0ALKhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 05:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020Ab0ALKhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 05:37:03 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:34871 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0ALKhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 05:37:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=dmpf4+bsr466MbLGdOofax7xWt8pJCmWmAnp12Xch6JUvyIr/TaDj4zZw8hTF1mWFF
         vfLgi8x+1ppyRDHc00rECJaO3fyI/fkMkts6z7Qgcz+17PkYhjy9uGFTl+3f3LOcqgM/
         Fgfkor4ZIs+yxCVW0ZC0YsXxP/z8Uc3W3zcxM=
MIME-Version: 1.0
Date: Tue, 12 Jan 2010 16:37:00 +0600
Message-ID: <b9df5fa11001120237o2461db60g1e0cfa97b3aef3@mail.gmail.com>
Subject: [PATCH] smp: Fix documentation in include/linux/smp.h
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	smp: Fix documentation.

Fix documentation in include/linux/smp.h: smp_processor_id()

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/include/linux/smp.h	2010-01-06 20:11:08.000000000 +0600
+++ rakib/include/linux/smp.h	2010-01-12 16:22:33.000000000 +0600
@@ -154,7 +154,7 @@ smp_call_function_any(const struct cpuma
 /*
  * smp_processor_id(): get the current CPU ID.
  *
- * if DEBUG_PREEMPT is enabled the we check whether it is
+ * if DEBUG_PREEMPT is enabled then we check whether it is
  * used in a preemption-safe way. (smp_processor_id() is safe
  * if it's used in a preemption-off critical section, or in
  * a thread that is bound to the current CPU.)
