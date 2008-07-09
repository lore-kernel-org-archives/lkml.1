Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbYGILzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbYGILzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbYGILyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:54:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:38546 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544AbYGILys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OUBGIvuGluIvIOsCAd7li7Qm2IXwars3WeG8XtS40IYSuktkTO7Ktham68cEb29RPQ
         E7bsxBCocwsSwc+9cZNFmAZsL8kVzuyyvMI94Bf/TQo9vXl/19k8hCrF6neLpqeziSIs
         PndORVmP2EIihY+R7GZ/YviYAHlb7fS1E+qPg=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Wed, 09 Jul 2008 20:55:02 +0900
Message-Id: <20080709115502.14144.49264.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
References: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
Subject: [PATCH 04/04] resource: add new IORESOURCE_CLK type
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch rearranges the values of the IORESOURCE_TYPE_BITS from
one bit per type to a 4-bit counter. Also, IORESOURCE_CLK is added.
Not sure if it is better to start counting from 0 instead of 1.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/linux/ioport.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- 0003/include/linux/ioport.h
+++ work/include/linux/ioport.h	2008-07-09 15:19:45.000000000 +0900
@@ -37,8 +37,9 @@ struct resource_list {
 #define IORESOURCE_TYPE_BITS	0x00000f00	/* Resource type */
 #define IORESOURCE_IO		0x00000100
 #define IORESOURCE_MEM		0x00000200
-#define IORESOURCE_IRQ		0x00000400
-#define IORESOURCE_DMA		0x00000800
+#define IORESOURCE_IRQ		0x00000300
+#define IORESOURCE_DMA		0x00000400
+#define IORESOURCE_CLK		0x00000500
 
 #define IORESOURCE_PREFETCH	0x00001000	/* No side effects */
 #define IORESOURCE_READONLY	0x00002000
