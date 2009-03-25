Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbZCYMec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbZCYMec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZCYMeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:34:24 -0400
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:34966 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456AbZCYMeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:34:23 -0400
Message-ID: <49CA24B6.103@kernel.org>
Date: Wed, 25 Mar 2009 13:33:58 +0100
From: Frank Seidel <fseidel@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
CC: akpm@linux-foundation.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Jim Keniston <jkenisto@us.ibm.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       Frank Seidel <frank@f-seidel.de>
Subject: [PATCH] trivial: remove warning from arch/x86/kernel/kprobes.c
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Remove warning (makes integer from pointer without a cast)
from build messages.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 arch/x86/kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -193,7 +193,7 @@ static int __kprobes can_boost(kprobe_op
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
 
-	if (search_exception_tables(opcodes))
+	if (search_exception_tables((unsigned long)opcodes))
 		return 0;	/* Page fault may occur on this address. */
 
 retry:
