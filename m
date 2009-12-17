Return-Path: <linux-kernel-owner+w=401wt.eu-S1763337AbZLQA5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763337AbZLQA5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763121AbZLQA5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:57:07 -0500
Received: from kroah.org ([198.145.64.141]:44530 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761478AbZLQAyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:43 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 16:47:08 2009
Message-Id: <20091217004708.835196603@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 16:46:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>
Subject: [13/18] x86: GART: pci-gart_64.c: Use correct length in strncmp
In-Reply-To: <20091217005306.GA6230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Joe Perches <joe@perches.com>

commit 41855b77547fa18d90ed6a5d322983d3fdab1959 upstream.

Signed-off-by: Joe Perches <joe@perches.com>
LKML-Reference: <1257818330.12852.72.camel@Joe-Laptop.home>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/pci-gart_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -865,7 +865,7 @@ void __init gart_parse_options(char *p)
 #endif
 	if (isdigit(*p) && get_option(&p, &arg))
 		iommu_size = arg;
-	if (!strncmp(p, "fullflush", 8))
+	if (!strncmp(p, "fullflush", 9))
 		iommu_fullflush = 1;
 	if (!strncmp(p, "nofullflush", 11))
 		iommu_fullflush = 0;


