Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0BVEzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 23:55:19 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:62314 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0BVEzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 23:55:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=NAeY7rBEPz5cPqVfan5vYpWtw1VFtzGIkxJckdheWzmc5y7NfjTykPINadUqXCWmto
         tGpmX+Vi7eZ59A8nw/cq3aEmM704NqNOjlAf/mi0R2Lace8qfMP76hc5tRRKBtQU1yjX
         oBoH6XRMXL28NFJg7RiXkAKzHmAz8JulLUCII=
Date: Mon, 22 Feb 2010 07:54:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mca: remove some dead code
Message-ID: <20100222045445.GA4853@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two return statements in a row.  The first return statement is
the correct one.  For the unused return statement, it is the 
mca_device_read_stored_pos() which returns mca_dev->pos[reg];

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/mca/mca-device.c b/drivers/mca/mca-device.c
index e7adf89..ff078f4 100644
--- a/drivers/mca/mca-device.c
+++ b/drivers/mca/mca-device.c
@@ -65,8 +65,6 @@ unsigned char mca_device_read_pos(struct mca_device *mca_dev, int reg)
 	struct mca_bus *mca_bus = to_mca_bus(mca_dev->dev.parent);
 
 	return mca_bus->f.mca_read_pos(mca_dev, reg);
-
-	return 	mca_dev->pos[reg];
 }
 EXPORT_SYMBOL(mca_device_read_pos);
 
