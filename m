Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbXIXQdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbXIXQdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760480AbXIXQ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:17 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47457 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760333AbXIXQ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:15 -0400
Date: Mon, 24 Sep 2007 09:21:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jeff@garzik.org, matthew@wil.cx,
       alex@nibbles.it, dac@conglom-o.org
Subject: [23/50] Fix "Fix DAC960 driver on machines which dont support
	64-bit DMA"
Message-ID: <20070924162115.GX13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-fix-dac960-driver-on-machines-which-don-t-support-64-bit-dma.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@linux-foundation.org>

commit 3558c9b3232b5f0fd9f32043a191eca20fca64c6 in mainline.

sparc32:

drivers/block/DAC960.c: In function 'DAC960_V1_EnableMemoryMailboxInterface':
drivers/block/DAC960.c:1168: error: 'DMA_32BIT_MASK' undeclared (first use in this function)
drivers/block/DAC960.c:1168: error: (Each undeclared identifier is reported only

Cc: <dac@conglom-o.org>
Cc: Alessandro Polverini <alex@nibbles.it>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/DAC960.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -31,6 +31,7 @@
 #include <linux/genhd.h>
 #include <linux/hdreg.h>
 #include <linux/blkpg.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>

-- 
