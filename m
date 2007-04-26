Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbXDZH2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbXDZH2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933382AbXDZH2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:28:47 -0400
Received: from imx12.toshiba.co.jp ([61.202.160.132]:57102 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455AbXDZH2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:28:45 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Subject: RE: [PATCH 2/2]  Fixed typo Intel RNG driver for2.6.21-rc7-mm1
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Date: Thu, 26 Apr 2007 16:27:42 +0900
Message-ID: <BF571719A4041A478005EF3F08EA6DF00433242E@pcsmail03.pcs.pc.ome.toshiba.co.jp>
Thread-Topic: [PATCH 2/2]  Fixed typo Intel RNG driver for2.6.21-rc7-mm1
Thread-Index: AceH0bxMW4B4SAmeR/Cn3hq5WE5iswAAeNsQ
From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <prarit@redhat.com>, "lkml" <linux-kernel@vger.kernel.org>,
       "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Thank you for the comment.
 
> ># Do you think that a "FWH not detected" message is noisy?
> 
> No, I think it helps understanding why there's no RNG device 
> in the system.

OK, the typo fixes patch was corrected.

 intel-rng.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.21-rc7-mm1/drivers/char/hw_random/intel-rng.c~	2007-04-26 13:41:53.000000000 +0900
+++ linux-2.6.21-rc7-mm1/drivers/char/hw_random/intel-rng.c	2007-04-26 16:26:16.000000000 +0900
@@ -365,7 +365,8 @@ static int __init mod_init(void)
 	pci_dev_put(dev);
 	iounmap(intel_rng_hw->mem);
 	kfree(intel_rng_hw);
-	goto out;
+	if (err)
+		goto out;
 
 fwh_done:
 	err = -ENOMEM;
