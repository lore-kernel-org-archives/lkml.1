Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbZIXV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbZIXV7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZIXV7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:59:52 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:62792 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZIXV7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=osl9a+DPmOhKQbO5UlvPB+/zV61j0Af9PHy2Q3itK5v0KRRYhvgXGF7+vildKwiFFh
         EqISpGKInKc1E3CygnDCLYCfmibdmbdJfjb2RNUn8ybSpvsw08uqZqyZ6/8OSWr/XTFq
         ePilns3E/lD4g/LX1NP4ua96hZh5RaBpsccvY=
Message-ID: <4ABBEBD8.8040809@gmail.com>
Date: Thu, 24 Sep 2009 14:59:52 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: comedi: fix formating errors in drivers/ni_atmio16d.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct formatting errors - in this case line length and spaces before
parens.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/ni_atmio16d.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 901833d..1e35ed6 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -200,8 +200,8 @@ struct atmio16d_private {
 	enum { dac_2comp, dac_straight } dac0_coding, dac1_coding;
 	const struct comedi_lrange *ao_range_type_list[2];
 	unsigned int ao_readback[2];
-	unsigned int com_reg_1_state;	/* current state of command register 1 */
-	unsigned int com_reg_2_state;	/* current state of command register 2 */
+	unsigned int com_reg_1_state; /* current state of command register 1 */
+	unsigned int com_reg_2_state; /* current state of command register 2 */
 };
 
 static void reset_counters(struct comedi_device *dev)
@@ -324,7 +324,7 @@ static int atmio16d_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique & mutually compatible */
 	/* note that mutual compatiblity is not an issue here */
 	if (cmd->scan_begin_src != TRIG_FOLLOW &&
 	    cmd->scan_begin_src != TRIG_EXT &&
@@ -436,10 +436,10 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
 	} else if (cmd->convert_arg < 655360000) {
 		base_clock = CLOCK_100_KHZ;
 		timer = cmd->convert_arg / 10000;
-	} else if (cmd->convert_arg <= 0xffffffff /* 6553600000 */ ) {
+	} else if (cmd->convert_arg <= 0xffffffff /* 6553600000 */) {
 		base_clock = CLOCK_10_KHZ;
 		timer = cmd->convert_arg / 100000;
-	} else if (cmd->convert_arg <= 0xffffffff /* 65536000000 */ ) {
+	} else if (cmd->convert_arg <= 0xffffffff /* 65536000000 */) {
 		base_clock = CLOCK_1_KHZ;
 		timer = cmd->convert_arg / 1000000;
 	}
@@ -504,10 +504,10 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
 		} else if (cmd->scan_begin_arg < 655360000) {
 			base_clock = CLOCK_100_KHZ;
 			timer = cmd->scan_begin_arg / 10000;
-		} else if (cmd->scan_begin_arg < 0xffffffff /* 6553600000 */ ) {
+		} else if (cmd->scan_begin_arg < 0xffffffff /* 6553600000 */) {
 			base_clock = CLOCK_10_KHZ;
 			timer = cmd->scan_begin_arg / 100000;
-		} else if (cmd->scan_begin_arg < 0xffffffff /* 65536000000 */ ) {
+		} else if (cmd->scan_begin_arg < 0xffffffff /* 65536000000 */) {
 			base_clock = CLOCK_1_KHZ;
 			timer = cmd->scan_begin_arg / 1000000;
 		}
-- 
1.6.5.rc2
