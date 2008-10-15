Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbYJOEnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbYJOEnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 00:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYJOEnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 00:43:47 -0400
Received: from gw.goop.org ([64.81.55.164]:52422 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbYJOEnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 00:43:46 -0400
Message-ID: <48F574FF.2040600@goop.org>
Date: Tue, 14 Oct 2008 21:43:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Cliff Wickman <cpw@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/tlb_uv: remove strange mc146818rtc include
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason tlb_uv was including linux/mc146818rtc.h.  It really
just needs linux/seq_file.h

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citix.com>
Cc: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -6,7 +6,7 @@
  *	This code is released under the GNU General Public License version 2 or
  *	later.
  */
-#include <linux/mc146818rtc.h>
+#include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
 


