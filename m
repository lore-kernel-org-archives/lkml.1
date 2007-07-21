Return-Path: <linux-kernel-owner+w=401wt.eu-S1764274AbXGUPIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764274AbXGUPIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939160AbXGUPDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:03:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938650AbXGUPD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=HM+hu+0+EDRM66xrnwmElj4ePPpycxk3jEWUlSFkbYFcgQw03vf046bTv49CundUHnFK95DO01kYipDD2BIDnUFLz53anVMHXeSFCzVLE0vSjU529awQyIsUDLGxqIFqVX347KJajaGkmFiAHlJUFSM/L6Xh3EwhLY0dr+MuZgE=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][09/37] Clean up duplicate includes in drivers/macintosh/
Date: Sat, 21 Jul 2007 17:02:30 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211702.30610.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/macintosh/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index 4177ff0..2c21d4f 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -30,7 +30,6 @@
 #include <asm/machdep.h>
 #include <asm/pmac_feature.h>
 #include <asm/dbdma.h>
-#include <asm/dbdma.h>
 #include <asm/macio.h>
 #include <asm/keylargo.h>
 
