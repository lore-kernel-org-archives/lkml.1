Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZGHQDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZGHQDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbZGHQCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:02:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:53069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014AbZGHQCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:02:50 -0400
Subject: [PATCH 20/44] includecheck fix: x86, shadow.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:29:39 +0530
Message-Id: <1247065179.4382.51.camel@ht.satnam>
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



