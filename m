Return-Path: <linux-kernel-owner+w=401wt.eu-S941348AbXGUPUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941348AbXGUPUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939555AbXGUPFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:05:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:41066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938565AbXGUPFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:05:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=rIKe+NTTZD1OKhNSZgMzxJWj513CIg4TGpZx6HGkiDNMjlN+XkrodS/CthSQ2E8eDxbYU6d6uGNrvJb95fNiu4yGZrf6wd2wcseHjzaGPWOut+7KiG3I8upmKukyrGYBQ4PusK4gVkm73PbJnfnPSWCPJYkxNYMrMy56NrJgARY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][35/37] Clean up duplicate includes in sound/core/
Date: Sat, 21 Jul 2007 17:04:03 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Jaroslav Kysela <perex@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211704.04089.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	sound/core/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index e470c3c..8a91cf8 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -30,7 +30,6 @@
 #include <linux/mutex.h>
 #include <linux/moduleparam.h>
 #include <linux/delay.h>
-#include <linux/wait.h>
 #include <sound/rawmidi.h>
 #include <sound/info.h>
 #include <sound/control.h>
