Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0BSR6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:58:38 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37419 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab0BSR63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:58:29 -0500
Subject: [PATCH v1 2/7] vsprintf: clarify comments for printf_spec flags
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 19 Feb 2010 10:58:28 -0700
Message-ID: <20100219175828.9199.12642.stgit@bob.kio>
In-Reply-To: <20100219175655.9199.30691.stgit@bob.kio>
References: <20100219175655.9199.30691.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add clues about what the SMALL and SPECIAL flags do.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 lib/vsprintf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b8aeec..212d047 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -381,8 +381,8 @@ static noinline char *put_dec(char *buf, unsigned long long num)
 #define PLUS	4		/* show plus */
 #define SPACE	8		/* space if plus */
 #define LEFT	16		/* left justified */
-#define SMALL	32		/* Must be 32 == 0x20 */
-#define SPECIAL	64		/* 0x */
+#define SMALL	32		/* use lowercase in hex (must be 32 == 0x20) */
+#define SPECIAL	64		/* prefix hex with "0x", octal with "0 */
 
 enum format_type {
 	FORMAT_TYPE_NONE, /* Just a string part */

