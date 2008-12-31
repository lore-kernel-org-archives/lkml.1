Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYLaIrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYLaIrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYLaIqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:46:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50658 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbYLaIqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:46:51 -0500
Message-ID: <495B313E.7060701@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 16:45:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] cpumask: fix bogus kernel-doc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix kernel-doc

alloc_bootmem_cpumask_var() returns avoid.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 lib/cpumask.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index a661634..3389e24 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -140,7 +140,7 @@ EXPORT_SYMBOL(alloc_cpumask_var);
  * @mask: pointer to cpumask_var_t where the cpumask is returned
  *
  * Only defined when CONFIG_CPUMASK_OFFSTACK=y, otherwise is
- * a nop returning a constant 1 (in <linux/cpumask.h>)
+ * a nop (in <linux/cpumask.h>).
  * Either returns an allocated (zero-filled) cpumask, or causes the
  * system to panic.
  */
-- 
1.5.4.rc3
