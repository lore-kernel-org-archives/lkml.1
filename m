Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbZDWHgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbZDWHgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbZDWH2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:28:54 -0400
Received: from sous-sol.org ([216.99.217.87]:48402 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755942AbZDWH2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:28:53 -0400
Message-Id: <20090423072348.362268028@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 027/100] ide: drivers/ide/ide-atapi.c needs <linux/scatterlist.h>
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=ide-drivers-ide-ide-atapi.c-needs-linux-scatterlist.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

upstream commit: 479edf065576aeed7ac99d10838bb3b4f870b5f9

On m68k:
| drivers/ide/ide-atapi.c: In function 'ide_io_buffers':
| drivers/ide/ide-atapi.c:87: error: implicit declaration of function 'sg_page'
| drivers/ide/ide-atapi.c:87: warning: passing argument 1 of 'PageHighMem' makes pointer from integer without a cast
| drivers/ide/ide-atapi.c:91: warning: passing argument 1 of 'kmap_atomic' makes pointer from integer without a cast
| drivers/ide/ide-atapi.c:96: error: implicit declaration of function 'sg_virt'
| drivers/ide/ide-atapi.c:96: warning: assignment makes pointer from integer without a cast
| drivers/ide/ide-atapi.c:107: error: implicit declaration of function 'sg_next'
| drivers/ide/ide-atapi.c:107: warning: assignment makes pointer from integer without a cast

[bart: Dmitri Vorobiev submitted similar patch fixing MIPS]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/ide/ide-atapi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -6,6 +6,8 @@
 #include <linux/cdrom.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
+#include <linux/scatterlist.h>
+
 #include <scsi/scsi.h>
 
 #ifdef DEBUG

