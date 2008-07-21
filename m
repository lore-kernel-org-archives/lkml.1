Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbYGUDEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbYGUDEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760209AbYGUDD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:03:57 -0400
Received: from ns.suse.de ([195.135.220.2]:33928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758832AbYGUDDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:03:55 -0400
Message-Id: <20080721025912.901688346@suse.de>
User-Agent: quilt/0.46_cvs20080326-18
Date: Mon, 21 Jul 2008 04:28:25 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [genksyms patch 2/4] Include extern information in dumps
References: <20080721022823.896799736@suse.de>
Content-Disposition: inline; filename=patches.suse/genksyms-dump.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extern flag currently is not included in type dump files
(genksyms --dump-types). Include that flag there for completeness.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 scripts/genksyms/genksyms.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/scripts/genksyms/genksyms.c
===================================================================
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -546,6 +546,8 @@ int main(int argc, char **argv)
 			}
 			fputs(sym->name, dumpfile);
 			putc(' ', dumpfile);
+			if (sym->is_extern)
+				fputs("extern ", dumpfile);
 			print_list(dumpfile, sym->defn);
 			putc('\n', dumpfile);
 


