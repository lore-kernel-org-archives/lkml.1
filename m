Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYDTKEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYDTKEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbYDTKEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:04:15 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4829 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbYDTKEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:04:14 -0400
Message-ID: <480B151A.2040601@xs4all.nl>
Date: Sun, 20 Apr 2008 12:04:10 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] w6692: replace deprecated pci_find_device
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: multipart/mixed;
 boundary="------------070308070805080805020402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070308070805080805020402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

Found this is still necessary for 2.6.25 for the w6692 hisax isdn cards.
Maybe someone has already prepared a patch?
If not you could use this one.


1. replace deprecated pci_find_device

Signed-off-by: Udo van den Heuvel <udovdh@xs4all.nl>

Kind regards,
Udo

--------------070308070805080805020402
Content-Type: text/x-patch;
 name="w6692.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="w6692.patch"

--- a/drivers/isdn/hisax/w6692.c	2008-04-20 11:57:26.000000000 +0200
+++ b/drivers/isdn/hisax/w6692.c	2008-04-20 11:57:48.000000000 +0200
@@ -1011,7 +1011,7 @@
 		return (0);
 
 	while (id_list[id_idx].vendor_id) {
-		dev_w6692 = pci_find_device(id_list[id_idx].vendor_id,
+		dev_w6692 = pci_get_device(id_list[id_idx].vendor_id,
 					    id_list[id_idx].device_id,
 					    dev_w6692);
 		if (dev_w6692) {

--------------070308070805080805020402--
