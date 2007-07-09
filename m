Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbXGIJe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbXGIJe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXGIJeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:34:20 -0400
Received: from mail.linux-boards.com ([192.114.83.142]:54070 "EHLO
	mail.linux-boards.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbXGIJeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:34:19 -0400
X-Greylist: delayed 2539 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 05:34:18 EDT
Message-ID: <4691F689.7000503@compulab.co.il>
Date: Mon, 09 Jul 2007 11:49:13 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.0 (X11/20070506)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@linux.it>
CC: linux-kernel@vger.kernel.org
Subject: PXA2xx keyboard driver fix
Content-Type: multipart/mixed;
 boundary="------------010405080007010904040703"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010405080007010904040703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The PXA2xx keyboard driver does not compile with 2.6.22
The following patch fixes it

Signed-off-by: Mike Rapoport <mike@compulab.co.il>



--------------010405080007010904040703
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

 drivers/input/keyboard/pxa27x_keyboard.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/pxa27x_keyboard.c b/drivers/input/keyboard/pxa27x_keyboard.c
index f9e82c9..ebe5eac 100644
--- a/drivers/input/keyboard/pxa27x_keyboard.c
+++ b/drivers/input/keyboard/pxa27x_keyboard.c
@@ -140,7 +140,7 @@ static int pxakbd_resume(struct platform_device *pdev)
 		KPREC = pdata->reg_kprec;
 
 		/* Enable unit clock */
-		pxa_set_cken(CKEN19_KEYPAD, 1);
+		pxa_set_cken(CKEN_KEYPAD, 1);
 	}
 
 	mutex_unlock(&input_dev->mutex);

--------------010405080007010904040703--
