Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbXH2DpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbXH2DpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 23:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbXH2Dox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 23:44:53 -0400
Received: from smtp28.orange.fr ([80.12.242.100]:41454 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbXH2Dow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 23:44:52 -0400
X-ME-UUID: 20070828130206913.DF01770000CC@mwinf2819.orange.fr
Message-ID: <46D41CCC.9040904@bachelot.org>
Date: Tue, 28 Aug 2007 15:02:04 +0200
From: Xavier Bachelot <xavier@bachelot.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: airlied@linux.ie, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: drm: VIA invalid device IDs removal
Content-Type: multipart/mixed;
 boundary="------------010500060903060506060501"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010500060903060506060501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Remove 2 invalid device ids from in-kernel drm tree.

0x1106, 0x7204 is unknown and thus is not an IGP/GPU.
0x1106, 0x3304 is K8M800 hostbridge, not an IGP/GPU.
None of them are in drm git tree.


--------------010500060903060506060501
Content-Type: text/x-patch;
 name="drm-via_invalid_ids_removal.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="drm-via_invalid_ids_removal.patch"

--- a/drivers/char/drm/drm_pciids.h	2007-08-28 14:08:27.000000000 +0200
+++ b/drivers/char/drm/drm_pciids.h	2007-08-28 14:17:12.000000000 +0200
@@ -236,10 +236,8 @@
 	{0x1106, 0x3022, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3118, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
 	{0x1106, 0x3122, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x1106, 0x7204, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x7205, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x1106, 0x3304, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3344, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \

--------------010500060903060506060501--

