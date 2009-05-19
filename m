Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbZESRJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbZESRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZESRJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:09:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:32798 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZESRJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JJpsCrg6tl+kZ0MeJ0FImH8sjLNA7Ea6atV5691v0tVOZU8bMEssu5kscDHAG7mEta
         dSMfWyIzil5jS6oKim+eIpHkJ/AZPTD7bJX+sLX2Opr8wwS1U5D5DKdviuct04rW2PEV
         rW/kI9qMjkiuGTsqZw2hz1ZM8ejeeh3zZleC0=
MIME-Version: 1.0
Date: Tue, 19 May 2009 21:09:53 +0400
Message-ID: <a4423d670905191009i450545f6le9c49e84c5ce94fd@mail.gmail.com>
Subject: staging: cpc-usb: wrong Makefile path
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-next <linux-next@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 9492a6f..cc1aac2 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -40,4 +40,4 @@ obj-$(CONFIG_PLAN9AUTH)               += p9auth/
 obj-$(CONFIG_HECI)             += heci/
 obj-$(CONFIG_LINE6_USB)                += line6/
 obj-$(CONFIG_USB_SERIAL_QUATECH_ESU100)        += serqt_usb/
-obj-$(CONFIG_USB_CPC)          += cpc_usb/
+obj-$(CONFIG_USB_CPC)          += cpc-usb/
