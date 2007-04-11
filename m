Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbXDKMru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbXDKMru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 08:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbXDKMru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 08:47:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:61485 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXDKMrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 08:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=sAFh7KJQ1s4qAXsknwXX+kXnBuLdBjk447Eq3Rm/V1ihCZ8i8Kqh8H0WNo8SpdUmdel8wtYEGiwW6ovatBgQM5rsX4fQF/waJo4av6C6FFqqSeXWhZdhdB83TdZWzttdq62kBbYqVaES1dfeDFAsnjSs2x7gyDLmaV0HUiec5YY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: trivial@kernel.org
Subject: [PATCH][trivial] Magic number prefix consistency change to Documentation/magic-number.txt
Date: Wed, 11 Apr 2007 14:47:22 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704111447.23186.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Very trivial patch to just fix a tiny thing that caught my eye while 
scrolling through the Documentation/magic-number.txt file. I noticed 
that all the magic numbers, except one, were listed with a "0x" prefix - 
the one that stands out is EEPROM_MAGIC_VALUE which has a "0X" prefix.
Change to a lower-case "x" to match the rest of the file.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Documentation/magic-number.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/magic-number.txt b/Documentation/magic-number.txt
index 0e740c8..bd450e7 100644
--- a/Documentation/magic-number.txt
+++ b/Documentation/magic-number.txt
@@ -129,7 +129,7 @@ SAVEKMSG_MAGIC1       0x53415645  savekmsg          
arch/*/amiga/config.c
 GDA_MAGIC             0x58464552  gda               
include/asm-mips64/sn/gda.h
 RED_MAGIC1            0x5a2cf071  (any)             mm/slab.c
 STL_PORTMAGIC         0x5a7182c9  stlport           include/linux/stallion.h
-EEPROM_MAGIC_VALUE    0X5ab478d2  lanai_dev         drivers/atm/lanai.c
+EEPROM_MAGIC_VALUE    0x5ab478d2  lanai_dev         drivers/atm/lanai.c
 HDLCDRV_MAGIC         0x5ac6e778  hdlcdrv_state     include/linux/hdlcdrv.h
 EPCA_MAGIC            0x5c6df104  channel           include/linux/epca.h
 PCXX_MAGIC            0x5c6df104  channel           drivers/char/pcxx.h
