Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZHIMht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZHIMht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 08:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZHIMht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 08:37:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:59124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZHIMhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 08:37:48 -0400
Subject: [PATCH] kmemcheck: includecheck fix for shadow.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Aug 2009 18:06:07 +0530
Message-Id: <1249821367.2957.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/x86/mm/kmemcheck/shadow.c: linux/module.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/mm/kmemcheck/shadow.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
index e773b6b..3f66b82 100644
--- a/arch/x86/mm/kmemcheck/shadow.c
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -1,7 +1,6 @@
 #include <linux/kmemcheck.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
-- 
1.6.0.6



