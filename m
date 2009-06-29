Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZF2EDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZF2EDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 00:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbZF2EC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 00:02:59 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:46780 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZF2EC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 00:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rj11TUa8hR0fkeVxc/eYVB1aPX2tkWlAP5MVZ02tkxKCpGEiqLEYSF6ZAHhp5Xclsm
         GIBJv4MDO+o0kb5qhosF18lBl4ISuuXiC9B6W/ZdpBU29DfJt1pONtjF0y1WD2GnVS1M
         7ivFwhChFngv8PvxYRqWytL3chJbRiegPBE3U=
Subject: [PATCH v2]highmem_32.c : clean up comment
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1246242173.2561.8.camel@myhost>
References: <1246242173.2561.8.camel@myhost>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 12:02:55 +0800
Message-Id: <1246248175.5759.12.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up comment.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---  
arch/x86/mm/highmem_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 58f621e..0c6f43c 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -24,7 +24,7 @@ void kunmap(struct page *page)
  * no global lock is needed and because the kmap code must perform a global TLB
  * invalidation when the kmap pool wraps.
  *
- * However when holding an atomic kmap is is not legal to sleep, so atomic
+ * However when holding an atomic kmap it is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  */
 void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)


