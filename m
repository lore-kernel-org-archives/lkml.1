Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbYG2UKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbYG2UKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYG2UJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:09:13 -0400
Received: from xenotime.net ([66.160.160.81]:54416 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752718AbYG2UJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:09:10 -0400
Date: Tue, 29 Jul 2008 13:05:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>,
       linux@dominikbrodowski.net
Subject: [PATCH 4/5] docsrc: fix crc32hash type
Message-ID: <1217361915584@xenotime.net>
In-Reply-To: <12173619152424@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix differing signedness warning:

Documentation/pcmcia/crc32hash.c:29: warning: pointer targets in passing argument 1 of 'crc32' differ in signedness

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/pcmcia/crc32hash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080729.orig/Documentation/pcmcia/crc32hash.c
+++ linux-next-20080729/Documentation/pcmcia/crc32hash.c
@@ -26,7 +26,7 @@ int main(int argc, char **argv) {
 		printf("no string passed as argument\n");
 		return -1;
 	}
-	result = crc32(argv[1], strlen(argv[1]));
+	result = crc32((unsigned char const *)argv[1], strlen(argv[1]));
 	printf("0x%x\n", result);
 	return 0;
 }


-- 

