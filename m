Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZIVNfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZIVNfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZIVNfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:35:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:33923 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbZIVNfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:35:36 -0400
Subject: [PATCH] PARISC: includecheck fix: signal.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Kyle McMartin <kyle@parisc-linux.org>, Helge Deller <deller@gmx.de>,
       linux-parisc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 19:05:32 +0530
Message-Id: <1253626532.3784.17.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/parisc/kernel/signal.c: linux/compat.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/parisc/kernel/signal.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 8eb3c63..5d5a710 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -34,7 +34,6 @@
 #include <asm/asm-offsets.h>
 
 #ifdef CONFIG_COMPAT
-#include <linux/compat.h>
 #include "signal32.h"
 #endif
 
-- 
1.6.0.6


