Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZIVNu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZIVNu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZIVNuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:50:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:34548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbZIVNuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:50:24 -0400
Subject: [PATCH] SH: includecheck fix: dwarf.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>, Matt Fleming <matt@console-pimps.org>,
       linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 19:20:26 +0530
Message-Id: <1253627426.3784.24.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/sh/kernel/dwarf.c: asm/dwarf.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/sh/kernel/dwarf.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/dwarf.c b/arch/sh/kernel/dwarf.c
index bc4d8d7..03b3616 100644
--- a/arch/sh/kernel/dwarf.c
+++ b/arch/sh/kernel/dwarf.c
@@ -24,7 +24,6 @@
 #include <asm/unwinder.h>
 #include <asm/sections.h>
 #include <asm/unaligned.h>
-#include <asm/dwarf.h>
 #include <asm/stacktrace.h>
 
 /* Reserve enough memory for two stack frames */
-- 
1.6.0.6


