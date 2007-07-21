Return-Path: <linux-kernel-owner+w=401wt.eu-S939000AbXGUPTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939000AbXGUPTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939476AbXGUPFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:05:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763902AbXGUPFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=gbyawBMuXvuGHuAKEHFNBdZrbfV7QseuvTbN9h/PA5g40x5NWgH2HFtVEW9L0JUHFxQThsfXvKqH7A2WH2uFABvzLPD4sYwZvXtnLeje+OK+Sj2vy161Tc46jvkZ5XqjKWnbOa+SN2K4q/bICXYJtqLtwAQ+WYpfKIBovVFdq3Y=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][37/37] Clean up duplicate includes in sound/soc/
Date: Sat, 21 Jul 2007 17:04:16 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Richard Purdie <richard@openedhand.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211704.17084.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	sound/soc/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/sound/soc/pxa/spitz.c b/sound/soc/pxa/spitz.c
index 80e8210..4dd8f35 100644
--- a/sound/soc/pxa/spitz.c
+++ b/sound/soc/pxa/spitz.c
@@ -34,7 +34,6 @@
 #include <asm/arch/hardware.h>
 #include <asm/arch/akita.h>
 #include <asm/arch/spitz.h>
-#include <asm/mach-types.h>
 #include "../codecs/wm8750.h"
 #include "pxa2xx-pcm.h"
 #include "pxa2xx-i2s.h"
