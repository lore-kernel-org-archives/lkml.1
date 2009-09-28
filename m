Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZI1VLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZI1VLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZI1VLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:11:20 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:65429 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZI1VLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:11:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CpytythISfSA96lhHYqAsYc32lsqLmHrREd9yYJ4/clRPv5opba7gJkDdZXwx4DG7E
         alvHYx870H5seNF4WIyzh+vryV/UxSSnJLuvANQYm90jT1VmqqQgiyIxFluNYrX/5vtx
         6XG0CLNKbTE9zde9t/1Mfn5ATJ9KhtTuP8Hk0=
Message-ID: <4AC12685.5030002@gmail.com>
Date: Mon, 28 Sep 2009 14:11:33 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: CodingStyle cleanup for drivers/acl722b.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup this file as per the coding style.  Adding KERN_INFO to
the printks.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/acl7225b.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index c3652ef..e6c6c87 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -94,7 +94,7 @@ static int acl7225b_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 	iorange = this_board->io_range;
-	printk("comedi%d: acl7225b: board=%s 0x%04x ", dev->minor,
+	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x ", dev->minor,
 	       this_board->name, iobase);
 	if (!request_region(iobase, iorange, "acl7225b")) {
 		printk("I/O port conflict\n");
@@ -137,14 +137,14 @@ static int acl7225b_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)ACL7225_DI_LO;
 
-	printk("\n");
+	printk(KERN_INFO "\n");
 
 	return 0;
 }
 
 static int acl7225b_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: acl7225b: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: acl7225b: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, this_board->io_range);
-- 
1.6.5.rc2
