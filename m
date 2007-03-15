Return-Path: <linux-kernel-owner+w=401wt.eu-S1750943AbXCOKHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943AbXCOKHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXCOKHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:07:54 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:44964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbXCOKHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:07:53 -0400
Subject: [PATCH] change misleading EFI partition support description
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 11:07:39 +0100
Message-Id: <1173953259.3349.8.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the misleading "Presently only useful on the IA-64
platform" text from the EFI partition Kconfig.

EFI partitions are also used by Apple on their Intel-based machines and
thus you need EFI partition support if you (for example) want to attach
such a machine in target disk mode.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- linux-2.6.orig/fs/partitions/Kconfig	2007-03-15 11:04:20.785467186 +0100
+++ linux-2.6/fs/partitions/Kconfig	2007-03-15 11:05:14.505467186 +0100
@@ -235,5 +235,4 @@ config EFI_PARTITION
 	select CRC32
 	help
 	  Say Y here if you would like to use hard disks under Linux which
-	  were partitioned using EFI GPT.  Presently only useful on the
-	  IA-64 platform.
+	  were partitioned using EFI GPT.


