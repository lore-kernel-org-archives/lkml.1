Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYGIQx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYGIQx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYGIQvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:37 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42843 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751976AbYGIQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:31 -0400
Message-Id: <20080709165131.350367000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:44 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 15/15] x86_64: Remove cpu_pda() macro
Content-Disposition: inline; filename=zero_based_remove_cpu_pda
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * As there are no more references to cpu_pda() then remove it.

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/pda.h |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.tip.orig/include/asm-x86/pda.h
+++ linux-2.6.tip/include/asm-x86/pda.h
@@ -39,8 +39,6 @@ struct x8664_pda {
 
 extern void pda_init(int);
 
-#define cpu_pda(cpu) (&per_cpu(pda, cpu))
-
 /*
  * proxy_pda doesn't actually exist, but tell gcc it is accessed for
  * all PDA accesses so it gets read/write dependencies right.

-- 
