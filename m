Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZDWTj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZDWTj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZDWTjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:39:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46685 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZDWTja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:39:30 -0400
Date: Thu, 23 Apr 2009 21:32:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Chris Zankel <chris@zankel.net>, David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ptrace: remove PT_DTRACE from arch/h8300
Message-ID: <20090423193202.GA14878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

h8300 defines PT_DTRACE for asm but never uses it.

DEFINE(PT_PTRACED, PT_PTRACED) seems to be unused too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 arch/h8300/kernel/asm-offsets.c |    1 -
 1 file changed, 1 deletion(-)

--- PTRACE/arch/h8300/kernel/asm-offsets.c~DT_1_NOP	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/h8300/kernel/asm-offsets.c	2009-04-22 21:29:00.000000000 +0200
@@ -55,7 +55,6 @@ int main(void)
 	DEFINE(LRET,  offsetof(struct pt_regs, pc)       - sizeof(long));
 
 	DEFINE(PT_PTRACED, PT_PTRACED);
-	DEFINE(PT_DTRACE, PT_DTRACE);
 
 	return 0;
 }

