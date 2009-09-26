Return-Path: <linux-kernel-owner+w=401wt.eu-S1750774AbZIZEdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbZIZEdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 00:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbZIZEdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 00:33:18 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:35456 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZIZEdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 00:33:17 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2009 00:32:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=bYlRebYm8SmVZgUgIBf4mnavxzwZSFvQ0n0cXSxWSbsTqNek9j57KQ2C2Okkgh+2jn
         PD3BzJJXXdn872799jJxH9kkZjCFQ1t8kNox1H8Ub9r5KB7Fql62XsCwLZvXKRxjnG5v
         fajWsT8Xe5+cBAonK0GxpoXgRmATm/hZib8C8=
Message-ID: <4ABD9990.1080606@gmail.com>
Date: Fri, 25 Sep 2009 21:33:20 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: comedi: cleanup formating in drivers/8255.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the formatting of braces to meet the coding standard.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/8255.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 0a50864..8ad3520 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -179,15 +179,14 @@ static int subdev_8255_insn_config(struct comedi_device *dev,
 	unsigned int bits;
 
 	mask = 1 << CR_CHAN(insn->chanspec);
-	if (mask & 0x0000ff) {
+	if (mask & 0x0000ff)
 		bits = 0x0000ff;
-	} else if (mask & 0x00ff00) {
+	else if (mask & 0x00ff00)
 		bits = 0x00ff00;
-	} else if (mask & 0x0f0000) {
+	else if (mask & 0x0f0000)
 		bits = 0x0f0000;
-	} else {
+	else
 		bits = 0xf00000;
-	}
 
 	switch (data[0]) {
 	case INSN_CONFIG_DIO_INPUT:
@@ -333,11 +332,10 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 		return -ENOMEM;
 
 	CALLBACK_ARG = arg;
-	if (cb == NULL) {
+	if (cb == NULL)
 		CALLBACK_FUNC = subdev_8255_cb;
-	} else {
+	else
 		CALLBACK_FUNC = cb;
-	}
 	s->insn_bits = subdev_8255_insn;
 	s->insn_config = subdev_8255_insn_config;
 
-- 
1.6.5.rc2
