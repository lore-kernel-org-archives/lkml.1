Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0CERrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:47:35 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:27018 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab0CERrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:47:32 -0500
Subject: [PATCH v2 2/7] vsprintf: clarify comments for printf_spec flags
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 05 Mar 2010 10:47:31 -0700
Message-ID: <20100305174731.21946.83296.stgit@bob.kio>
In-Reply-To: <20100305174656.21946.93874.stgit@bob.kio>
References: <20100305174656.21946.93874.stgit@bob.kio>
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
index af4aaa6..55d81e3 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -381,8 +381,8 @@ static noinline char *put_dec(char *buf, unsigned long long num)
 #define PLUS	4		/* show plus */
 #define SPACE	8		/* space if plus */
 #define LEFT	16		/* left justified */
-#define SMALL	32		/* Must be 32 == 0x20 */
-#define SPECIAL	64		/* 0x */
+#define SMALL	32		/* use lowercase in hex (must be 32 == 0x20) */
+#define SPECIAL	64		/* prefix hex with "0x", octal with "0" */
 
 enum format_type {
 	FORMAT_TYPE_NONE, /* Just a string part */

