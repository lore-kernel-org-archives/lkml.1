Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYFUTXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYFUTXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYFUTWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:22:21 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:54980 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYFUTWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=by1IeSPTeZsu+AyFAGrgR5J2Cv5AvXCSE/r+cX5W55aqnrkO+2yFekUTxltxxsI6l/
         wRa629uM2GKa3JJtyriH6XNsxuFTFnox3L8xTigKN8mQQyr9PY1ZisvADolph3C1Oqud
         fpq740BynU5z33sdbZke1oInaP1ikZy2A/zzA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/4] ide: mark hpt34x host driver as BROKEN
Date: Sat, 21 Jun 2008 21:12:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806212112.27748.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox has noticed some time ago that hpt34x is broken
(http://lkml.org/lkml/2007/7/3/257):

"No the old driver doesn't even do that. It starts up. It spuriously
adjusts some non writable PCI BAR registers, prints a message about
resources being in use already then exits."

Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -548,6 +548,7 @@ config BLK_DEV_CS5535
 
 config BLK_DEV_HPT34X
 	tristate "HPT34X chipset support"
+	depends on BROKEN
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds up to 4 more EIDE devices sharing a single
