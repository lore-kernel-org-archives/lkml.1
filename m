Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYHTONp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYHTONp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbYHTONg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:13:36 -0400
Received: from hs-out-0708.google.com ([64.233.178.242]:52931 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbYHTONf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IreBa1DHaBK/9qBKyEFhrb+TJW8HgVTP4B6PRtHGj77zNdR2cEcihkUxhKt9Uikg0F
         tyd5u7N/L8RnV916MvrZALPfpxoh/q/MI6kH2FT8QcVMOEGZZLRCOAGKZgURgulWEf0D
         rseoAzijM0doDGCVP6Vzq5IFZl3o/UiESFQDA=
Date: Wed, 20 Aug 2008 18:13:29 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: jbaron@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/module: fix warning when
	!CONFIG_DYNAMIC_PRINTK_DEBUG
Message-ID: <20080820141329.GB7622@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

kernel/module.c: In function 'load_module':
kernel/module.c:1839: warning: unused variable 'value'
kernel/module.c:1838: warning: unused variable 'iter'


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 kernel/module.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1721320..5a1258e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1835,8 +1835,10 @@ static struct module *load_module(void __user *umod,
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
 	unsigned int verboseindex;
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
 	struct mod_debug *iter;
 	unsigned long value;
+#endif
 	unsigned int tracepointsindex;
 	unsigned int tracepointsstringsindex;
 	struct module *mod;
