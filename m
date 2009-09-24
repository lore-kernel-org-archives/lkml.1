Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbZIXWCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbZIXWCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZIXWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:02:35 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:56692 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZIXWCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JdOG+w+7zDT5yae+LCH++AarWuVzlsGa8DXe6vIQNRYm+bpNPzgqidQdSpxCnHAeTo
         TRwc+yIxGytPlElUZi01pVEc+kk2E1mvE0he6N6ENazUVGrk2h9xJPNak9jmGKcDKw/4
         vdIovy9oyo4ZUMZe8DF2OGgNw0moi9MajQF/s=
Message-ID: <4ABBEC7C.3050406@gmail.com>
Date: Thu, 24 Sep 2009 15:02:36 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: comedi: fix formatting errors in drivers/nt_atmio16d.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn spaces into tabs to keep scripts/checkpatch.pl happy.  The
actual changes here are in a comment, so the script is just
being silly.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/ni_atmio16d.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index d76663f..c8876dc 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -700,29 +700,29 @@ static int atmio16d_dio_insn_config(struct comedi_device *dev,
 /*
    options[0] - I/O port
    options[1] - MIO irq
-                0 == no irq
-                N == irq N {3,4,5,6,7,9,10,11,12,14,15}
+		0 == no irq
+		N == irq N {3,4,5,6,7,9,10,11,12,14,15}
    options[2] - DIO irq
-                0 == no irq
-                N == irq N {3,4,5,6,7,9}
+		0 == no irq
+		N == irq N {3,4,5,6,7,9}
    options[3] - DMA1 channel
-                0 == no DMA
-                N == DMA N {5,6,7}
+		0 == no DMA
+		N == DMA N {5,6,7}
    options[4] - DMA2 channel
-                0 == no DMA
-                N == DMA N {5,6,7}
+		0 == no DMA
+		N == DMA N {5,6,7}
 
    options[5] - a/d mux
-   	0=differential, 1=single
+	0=differential, 1=single
    options[6] - a/d range
-   	0=bipolar10, 1=bipolar5, 2=unipolar10
+	0=bipolar10, 1=bipolar5, 2=unipolar10
 
    options[7] - dac0 range
-   	0=bipolar, 1=unipolar
+	0=bipolar, 1=unipolar
    options[8] - dac0 reference
-    0=internal, 1=external
+	0=internal, 1=external
    options[9] - dac0 coding
-   	0=2's comp, 1=straight binary
+	0=2's comp, 1=straight binary
 
    options[10] - dac1 range
    options[11] - dac1 reference
-- 
1.6.5.rc2
