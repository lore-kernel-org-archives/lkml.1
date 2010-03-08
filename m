Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0CHVZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:25:19 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:47319 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab0CHVZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:25:16 -0500
Subject: [PATCH] Staging: comedi: fix space before tabs coding style issue
 in adl_pci6208.c
From: Jaakko =?ISO-8859-1?Q?Niemel=E4?= <jjackpot@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, kost@linux.hr, mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 23:24:44 +0200
Message-ID: <1268083484.8863.11.camel@ELITE>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0231356b187c02cffcc28b809d392650e0da7822 Mon Sep 17 00:00:00 2001
From: =?utf-8?q?Jaakko=20Niemel=C3=A4?= <mato@kyborgi.net>
Date: Mon, 8 Mar 2010 22:20:33 +0200
Subject: [PATCH] Staging: comedi: fix space before tabs coding style issue in adl_pci6208.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

This is a patch to the adl_pci6208.c file that fixes up a space before tabs warning found by checkpatch.pl tool.
Signed-off-by: Jaakko Niemelä <mato@kyborgi.net>
---
 drivers/staging/comedi/drivers/adl_pci6208.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 6925faa..712b9e0 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -54,7 +54,7 @@ References:
 #include "../comedidev.h"
 #include "comedi_pci.h"
 
-#define PCI6208_DRIVER_NAME 	"adl_pci6208"
+#define PCI6208_DRIVER_NAME	"adl_pci6208"
 
 /* Board descriptions */
 struct pci6208_board {
@@ -134,10 +134,10 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data);
 /* static int pci6208_dio_insn_bits (struct comedi_device *dev,
- * 					struct comedi_subdevice *s, */
+ *					struct comedi_subdevice *s, */
 /* struct comedi_insn *insn,unsigned int *data); */
 /* static int pci6208_dio_insn_config(struct comedi_device *dev,
- * 					struct comedi_subdevice *s, */
+ *					struct comedi_subdevice *s, */
 /* struct comedi_insn *insn,unsigned int *data); */
 
 /*
@@ -268,7 +268,7 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
  * This allows packed reading/writing of the DIO channels.  The
  * comedi core can convert between insn_bits and insn_read/write */
 /* static int pci6208_dio_insn_bits(struct comedi_device *dev,
- * 					struct comedi_subdevice *s, */
+ *					struct comedi_subdevice *s, */
 /* struct comedi_insn *insn,unsigned int *data) */
 /* { */
 /* if(insn->n!=2)return -EINVAL; */
@@ -293,7 +293,7 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 /* } */
 
 /* static int pci6208_dio_insn_config(struct comedi_device *dev,
- * 					struct comedi_subdevice *s, */
+ *					struct comedi_subdevice *s, */
 /* struct comedi_insn *insn,unsigned int *data) */
 /* { */
 /* int chan=CR_CHAN(insn->chanspec); */
-- 
1.6.3.3



