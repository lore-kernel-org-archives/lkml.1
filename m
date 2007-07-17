Return-Path: <linux-kernel-owner+w=401wt.eu-S935456AbXGQSMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935456AbXGQSMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbXGQSL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:11:58 -0400
Received: from v32413.1blu.de ([88.84.155.73]:44697 "EHLO mail.lenk.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426AbXGQSL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:11:57 -0400
X-Greylist: delayed 1242 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 14:11:57 EDT
From: Frank Lichtenheld <frank@lichtenheld.de>
To: perex@suse.cz
Cc: torvalds@linux-foundation.org, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Frank Lichtenheld <frank@lichtenheld.de>
Subject: [PATCH] mixart: Add missing vmalloc.h include
Date: Tue, 17 Jul 2007 19:50:53 +0200
Message-Id: <11846946531651-git-send-email-frank@lichtenheld.de>
X-Mailer: git-send-email 1.5.2.GIT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following build error:
  CC      sound/pci/mixart/mixart_hwdep.o
sound/pci/mixart/mixart_hwdep.c: In function ‘mixart_hwdep_dsp_load’:
sound/pci/mixart/mixart_hwdep.c:610: error: implicit declaration of function ‘vmalloc’
sound/pci/mixart/mixart_hwdep.c:617: error: implicit declaration of function ‘vfree’

Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
---
 sound/pci/mixart/mixart_hwdep.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

  Against linus' tree from today

diff --git a/sound/pci/mixart/mixart_hwdep.c b/sound/pci/mixart/mixart_hwdep.c
index 1d9232d..170781a 100644
--- a/sound/pci/mixart/mixart_hwdep.c
+++ b/sound/pci/mixart/mixart_hwdep.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/firmware.h>
+#include <linux/vmalloc.h>
 #include <asm/io.h>
 #include <sound/core.h>
 #include "mixart.h"
-- 
1.5.1.2

