Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbYCOLrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbYCOLrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 07:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYCOLrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 07:47:22 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64270 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYCOLrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 07:47:21 -0400
X-Greylist: delayed 657 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Mar 2008 07:47:21 EDT
Message-ID: <47DBB442.90509@freemail.hu>
Date: Sat, 15 Mar 2008 12:34:26 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>
CC: Shankar Giri V <shankargiri@gmail.com>, dri-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] change the type of Unichrome display adapter (PCI ID=1106:3108)
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Change the type of Unichrome display adapter with PCI ID=1106:3108 to
get rid of message "irq 16: nobody cared".

See http://bugzilla.kernel.org/show_bug.cgi?id=8641 for details.

Signed-off-by: Shankar Giri V <shankargiri@gmail.com>
Signed-off-by: Márton Németh <nm127@freemail.hu>
---

--- linux-2.6.25-rc5/drivers/char/drm/drm_pciids.h.orig	2008-03-15 10:58:49.000000000 +0100
+++ linux-2.6.25-rc5/drivers/char/drm/drm_pciids.h	2008-03-15 10:59:31.000000000 +0100
@@ -335,7 +335,7 @@
 	{0x1106, 0x3118, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
 	{0x1106, 0x3122, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x7205, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x1106, 0x3108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
+	{0x1106, 0x3108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
 	{0x1106, 0x3344, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
