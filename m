Return-Path: <linux-kernel-owner+w=401wt.eu-S1030277AbXBTQwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030277AbXBTQwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXBTQwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:52:12 -0500
Received: from [81.2.110.250] ([81.2.110.250]:48597 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030277AbXBTQwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:52:10 -0500
Date: Tue, 20 Feb 2007 17:56:00 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] siimage: DRAC4 note
Message-ID: <20070220175600.43476be1@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Dell DRAC4 has some interesting features including effectively hot
unplugging/replugging the virtual CD interface when the DRAC is reset.
This often causes drivers/ide/siimage to panic but is ok with the rather
smarter code in libata.

Just note this fact in the driver docs.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/pci/siimage.c linux-2.6.20-mm2/drivers/ide/pci/siimage.c
--- linux.vanilla-2.6.20-mm2/drivers/ide/pci/siimage.c	2007-02-20 13:38:01.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ide/pci/siimage.c	2007-02-20 13:59:44.000000000 +0000
@@ -26,6 +26,9 @@
  *	If you have strange problems with nVidia chipset systems please
  *	see the SI support documentation and update your system BIOS
  *	if neccessary
+ *
+ *	If you are using a Dell DRAC4 you should use the libata driver
+ *	if possible.
  */
 
 #include <linux/types.h>

