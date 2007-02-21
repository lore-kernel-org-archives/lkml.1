Return-Path: <linux-kernel-owner+w=401wt.eu-S1751278AbXBUOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbXBUOtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbXBUOtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:49:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46953 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278AbXBUOtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:49:18 -0500
Date: Wed, 21 Feb 2007 15:52:43 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] siimage: DRAC4 note
Message-ID: <20070221155243.28a7ab5c@lxorguk.ukuu.org.uk>
In-Reply-To: <200702201948.25730.bzolnier@gmail.com>
References: <20070220175600.43476be1@localhost.localdomain>
	<45DB2855.9010705@garzik.org>
	<200702201948.25730.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Revised DRAC4 warning as Jeff suggested, this one includes more info
about why the problem occurs

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/pci/siimage.c linux-2.6.20-mm2/drivers/ide/pci/siimage.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/pci/siimage.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/pci/siimage.c	2007-02-21 14:30:08.187487864 +0000
@@ -26,6 +26,11 @@
  *	If you have strange problems with nVidia chipset systems please
  *	see the SI support documentation and update your system BIOS
  *	if neccessary
+ *
+ *  The Dell DRAC4 has some interesting features including effectively hot
+ *  unplugging/replugging the virtual CD interface when the DRAC is reset.
+ *  This often causes drivers/ide/siimage to panic but is ok with the rather
+ *  smarter code in libata.
  */
 
 #include <linux/types.h>
