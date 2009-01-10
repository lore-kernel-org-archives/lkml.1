Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbZAJSKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbZAJSKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZAJSKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:10:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:47260 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZAJSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:10:31 -0500
Subject: [PATCH -tip] x86: module_32.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 23:38:13 +0530
Message-Id: <1231610893.3994.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Fix:

 ERROR: code indent should use tabs where possible
 ERROR: trailing whitespace
 ERROR: spaces required around that '=' (ctx:VxW)

 total: 3 errors, 0 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/module_32.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/module_32.c b/arch/x86/kernel/module_32.c
index 3db0a54..0edd819 100644
--- a/arch/x86/kernel/module_32.c
+++ b/arch/x86/kernel/module_32.c
@@ -42,7 +42,7 @@ void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
 	/* FIXME: If module_region == mod->init_region, trim exception
-           table entries. */
+	   table entries. */
 }
 
 /* We don't need anything special. */
@@ -113,13 +113,13 @@ int module_finalize(const Elf_Ehdr *hdr,
 		*para = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
-	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) { 
+	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
 		if (!strcmp(".text", secstrings + s->sh_name))
 			text = s;
 		if (!strcmp(".altinstructions", secstrings + s->sh_name))
 			alt = s;
 		if (!strcmp(".smp_locks", secstrings + s->sh_name))
-			locks= s;
+			locks = s;
 		if (!strcmp(".parainstructions", secstrings + s->sh_name))
 			para = s;
 	}
-- 
1.5.6.6



