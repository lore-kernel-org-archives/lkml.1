Return-Path: <linux-kernel-owner+w=401wt.eu-S1756447AbXJXLWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbXJXLWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXJXLWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:22:43 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:62978 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752624AbXJXLWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:22:43 -0400
Date: Wed, 24 Oct 2007 13:22:20 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [GIT PATCH] Fix asm-avr32/dma-mapping.h breakage
Message-ID: <20071024132220.14070582@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry about sending you pull requests so rapidly, but Jens broke my
dma-mapping.h yesterday. Or you may say the bug was there to begin with
and Jens merely exposed it, but that makes it sound like my fault ;-)

Anyway, please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus

to receive the following update.

Haavard Skinnemoen (1):
      AVR32: Fix sg_page breakage

 include/asm-avr32/dma-mapping.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-avr32/dma-mapping.h b/include/asm-avr32/dma-mapping.h
index a713163..57dc672 100644
--- a/include/asm-avr32/dma-mapping.h
+++ b/include/asm-avr32/dma-mapping.h
@@ -3,7 +3,7 @@
 
 #include <linux/mm.h>
 #include <linux/device.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <asm/processor.h>
 #include <asm/cacheflush.h>
 #include <asm/io.h>
