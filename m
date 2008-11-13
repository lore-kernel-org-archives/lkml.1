Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYKMTmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYKMTmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYKMTe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:26 -0500
Received: from gw.goop.org ([64.81.55.164]:34411 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbYKMTeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:10 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 16 of 38] x86: include linux/init.h in asm/numa_64.h
X-Mercurial-Node: cb056d12d20309dd192e7f6e796af898f74833d0
Message-Id: <cb056d12d20309dd192e.1226603414@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It uses __init/__cpuinit, which are not defined otherwise.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/numa_64.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_NUMA_64_H
 #define _ASM_X86_NUMA_64_H
 
+#include <linux/init.h>
 #include <linux/nodemask.h>
 #include <asm/apicdef.h>
 


