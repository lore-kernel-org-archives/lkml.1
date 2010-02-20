Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab0BTLxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 06:53:11 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50686 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab0BTLxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 06:53:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PyKiKBtdSiGBD+GfmB+uLEZPV4r+pDEhfWt8PQCAlkCdOnVET9rwVYA/YvLoPiXf89
         n24meLgUbGiBTLUUka6wlI82mqIllTsHUVo3lduOtmxWdOfqimGn8HQaMK9yGuLQLt2C
         Z9gR8c1DJkedCh0v9o8tuyI/jdUjRj2tB3+MA=
From: Graham M Howe <gman.1352@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Graham M Howe <gman.1352@googlemail.com>
Subject: [PATCH 5/5] Staging: comedi: fix bracing and kfree issue in ni_670x.c This is a patch to the ni_670x.c file that fixes up brace and kfree issue found by checkpatch.pl tool Signed-off-by: Graham M Howe<gman.1352@googlemail.com>
Date: Sat, 20 Feb 2010 11:53:01 +0000
Message-Id: <1266666781-2178-1-git-send-email-gman.1352@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/ni_670x.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index fc5f90f..352b917 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -221,8 +221,6 @@ static int ni_670x_detach(struct comedi_device *dev)
 {
 	printk("comedi%d: ni_670x: remove\n", dev->minor);

-	if (dev->subdevices[0].range_table_list)
-		kfree(dev->subdevices[0].range_table_list);

 	if (dev->private && devpriv->mite)
 		mite_unsetup(devpriv->mite);
--
1.6.3.3

