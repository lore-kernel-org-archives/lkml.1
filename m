Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZFDMmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZFDMmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZFDMll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:41:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:38697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbZFDMlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:41:39 -0400
Subject: [PATCH 3/6] headers_check fix: m68k, swab.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, zippel@linux-m68k.org,
       linux-m68k@vger.kernel.org
In-Reply-To: <1244118599.5172.31.camel@ht.satnam>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244118476.5172.29.camel@ht.satnam>  <1244118599.5172.31.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 18:01:54 +0530
Message-Id: <1244118714.5172.33.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make headers_check' warnings:

  usr/include/asm-m68k/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
  usr/include/asm-m68k/swab.h:10: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/m68k/include/asm/swab.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/swab.h b/arch/m68k/include/asm/swab.h
index 9e3054e..5b754aa 100644
--- a/arch/m68k/include/asm/swab.h
+++ b/arch/m68k/include/asm/swab.h
@@ -1,7 +1,7 @@
 #ifndef _M68K_SWAB_H
 #define _M68K_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 #define __SWAB_64_THRU_32__
-- 
1.6.0.6



