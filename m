Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbXGCUDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbXGCUDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbXGCUD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:03:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:44582 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbXGCUD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XQgJpSMmf2e1HL4Ar+rS377w/a7hfhjKmHwIn3C/scggyHoaaIgWxje6LhG8oiFEinwRf+wUjI7ipGAACZcuhLnzOW3prHqBUNxR+a0jfjni4ewOqBj7v3/GqlfBDbVkpGGnLsOIK3W6FvMUTV+d7lznqE+O3ooWKxVV0Z6Yzaw=
Message-ID: <a9e22dff0707031303i30c08439t3cc48fb1b95f29b8@mail.gmail.com>
Date: Tue, 3 Jul 2007 23:03:23 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] for NIKON D50 as UMS
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This short patch allows NIKON D50 to be mounted as UMS on 2.6.22-rc7,
some previous kernels...


--- linux-2.6.22-rc7/drivers/usb/storage/unusual_devs.h 2007-07-03
22:54:23.000000000 +0300
+++ linux-2.6.22-rc7-niam/drivers/usb/storage/unusual_devs.h
2007-07-03 22:35:39.000000000 +0300
@@ -313,6 +313,13 @@
                US_SC_DEVICE, US_PR_DEVICE,NULL,
                US_FL_NOT_LOCKABLE ),

+/* Reported by Niam <niam.niam@gmail.com> */
+UNUSUAL_DEV(  0x04b0, 0x0409, 0x0100, 0x0100,
+               "NIKON",
+               "NIKON DSC D50",
+               US_SC_DEVICE, US_PR_DEVICE, NULL,
+               US_FL_FIX_CAPACITY),
+
 /* Reported by Andreas Bockhold <andreas@bockionline.de> */
 UNUSUAL_DEV(  0x04b0, 0x0405, 0x0100, 0x0100,
                "NIKON",
