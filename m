Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZGHQCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZGHQCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbZGHQC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:02:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:53047 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbZGHQC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:02:29 -0400
Subject: [PATCH 18/44] includecheck fix: x86, dumpstack.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:27:05 +0530
Message-Id: <1247065025.4382.47.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/x86/kernel/dumpstack.c: linux/ftrace.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/dumpstack.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c840571..2d8a371 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -15,7 +15,6 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/sysfs.h>
-#include <linux/ftrace.h>
 
 #include <asm/stacktrace.h>
 
-- 
1.6.0.6



