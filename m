Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbXAYBPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbXAYBPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 20:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXAYBPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 20:15:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:60910 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXAYBPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 20:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=n4ZbEZK4BSsdaW4yH+8X0sTHfI18FsGcfqDuNLt6yebRvh0mv74V8YprkdDvnzbHrzHtiDfvGcjMxFTJKW2h5VyU+wkf/E7dYQKLvnBQQsivnNzXOOpXmfFaBpU7KKTVp9FDEa2dQUTxuQ/Ogyd7dOWSWsdG33L8P0DdmLUCaJY=
Message-ID: <c1cd85210701241715p29fb437dy9400e74afaf8bbf7@mail.gmail.com>
Date: Thu, 25 Jan 2007 12:15:51 +1100
From: "Gordon Stanton" <fixacpi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add Micro-Star as a PCI VENDOR
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       lm-sensors@lm-sensors.org, s270-linux@mail.0pointer.de,
       linux-pci@atrey.karlin.mff.cuni.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I noticed that a common motherboard manufacturer Micro-Star was
missing it's PCI_VENDOR_ID and so I have sent this patch in.
Later on I will send a patch to pci/quirks.c to unhide the SMBus on
the M510C laptop once I have investigated it a bit more. It hides the
SMBus the same as ASUS (and a couple of others) laptops.
This is definately the correct ID, see
http://www.pcidatabase.com/vendor_details.php?id=705

I would also be happy with PCI_VENDOR_ID_MICRO_STAR instead, what do you think?

Signed-off-by: Gordon Stanton <fixacpi@gmail.com>

---

--- linux-2.6.20-rc5/include/linux/pci_ids.h	2007-01-13 05:54:26.000000000 +1100
+++ linux/include/linux/pci_ids.h	2007-01-25 11:43:30.478249500 +1100
@@ -1875,6 +1875,8 @@

 #define PCI_VENDOR_ID_SAMSUNG		0x144d

+#define PCI_VENDOR_ID_MICROSTAR		0x1462
+
 #define PCI_VENDOR_ID_MYRICOM		0x14c1

 #define PCI_VENDOR_ID_TITAN		0x14D2
