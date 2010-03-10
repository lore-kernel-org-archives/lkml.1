Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0CJJAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:00:08 -0500
Received: from smtp3.ugent.be ([157.193.49.127]:60063 "EHLO smtp3.UGent.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab0CJJAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:00:01 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 04:00:01 EST
Subject: [PATCH] Staging: comedi: fix whitespace coding style issues in
 comedi_fops.c
From: Pieter De Praetere <pieterc.depraetere@ugent.be>
To: greg@kroah.com
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 10 Mar 2010 09:47:44 +0100
Message-Id: <1268210864.8699.5.camel@pieter-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Miltered: at mcheck3 with ID 4B975E14.00A by Joe's j-chkmail (http://helpdesk.ugent.be/email/)!
X-j-chkmail-Enveloppe: 4B975E14.00A/157.193.13.39/vpnr039.ugent.be/[157.193.13.39]/<pieterc.depraetere@ugent.be>
X-j-chkmail-Score: MSGID : 4B975E14.00A on smtp3.UGent.be : j-chkmail score : . : R=. U=. O=. B=0.000 -> S=0.000
X-j-chkmail-Status: Ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 426e01adc11b6ab12ca7059482a15fd33a6f427f Mon Sep 17 00:00:00 2001
From: Pieter De Praetere <pieterc.depraetere@ugent.be>
Date: Wed, 10 Mar 2010 09:09:58 +0100
Subject: [PATCH] Staging: comedi: fix whitespace coding style issues in comedi_fops.c
 Solves warnings found by the checkpatch.pl tool: spaces before tabs.
 Signed-off-by: Pieter De Praetere <pieterc.depraetere@ugent.be>

---
 drivers/staging/comedi/comedi_fops.c |   39 +++++++++++++++++----------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index aca9674..287a1af 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -598,19 +598,19 @@ copyback:
 static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
 		      unsigned int *data, void *file);
 /*
- * 	COMEDI_INSNLIST
- * 	synchronous instructions
+ *	COMEDI_INSNLIST
+ *	synchronous instructions
  *
- * 	arg:
- * 		pointer to sync cmd structure
+ *	arg:
+ *		pointer to sync cmd structure
  *
- * 	reads:
- * 		sync cmd struct at arg
- * 		instruction list
- * 		data (for writes)
+ *	reads:
+ *		sync cmd struct at arg
+ *		instruction list
+ *		data (for writes)
  *
- * 	writes:
- * 		data (for reads)
+ *	writes:
+ *		data (for reads)
  */
 /* arbitrary limits */
 #define MAX_SAMPLES 256
@@ -894,18 +894,18 @@ out:
 }

 /*
- * 	COMEDI_INSN
- * 	synchronous instructions
+ *	COMEDI_INSN
+ *	synchronous instructions
  *
- * 	arg:
- * 		pointer to insn
+ *	arg:
+ *		pointer to insn
  *
- * 	reads:
- * 		struct comedi_insn struct at arg
- * 		data (for writes)
+ *	reads:
+ *		struct comedi_insn struct at arg
+ *		data (for writes)
  *
- * 	writes:
- * 		data (for reads)
+ *	writes:
+ *		data (for reads)
  */
 static int do_insn_ioctl(struct comedi_device *dev, void *arg, void *file)
 {
@@ -2105,6 +2105,7 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 		kfree(info->device);
 		kfree(info);
 		printk(KERN_ERR
+
 		       "comedi: error: ran out of minor numbers for board device files.\n");
 		return -EBUSY;
 	}
--
1.6.0.4



