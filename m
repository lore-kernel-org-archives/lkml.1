Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbXFWVjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbXFWVjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 17:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXFWVjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 17:39:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15513 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbXFWVjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 17:39:10 -0400
Date: Sat, 23 Jun 2007 14:40:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: perex@suse.cz, akpm <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: use __devexit_p
Message-Id: <20070623144022.94eb0f27.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Change __devexit to __devexit_p:
sound/isa/opl3sa2.c:956: error: expected expression before '__attribute__'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/isa/opl3sa2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22-rc5-git8.orig/sound/isa/opl3sa2.c
+++ linux-2.6.22-rc5-git8/sound/isa/opl3sa2.c
@@ -953,7 +953,7 @@ static int snd_opl3sa2_isa_resume(struct
 static struct isa_driver snd_opl3sa2_isa_driver = {
 	.match		= snd_opl3sa2_isa_match,
 	.probe		= snd_opl3sa2_isa_probe,
-	.remove		= __devexit( snd_opl3sa2_isa_remove),
+	.remove		= __devexit_p(snd_opl3sa2_isa_remove),
 #ifdef CONFIG_PM
 	.suspend	= snd_opl3sa2_isa_suspend,
 	.resume		= snd_opl3sa2_isa_resume,
