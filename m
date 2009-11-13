Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZKMCN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZKMCN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 21:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZKMCNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 21:13:51 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:54351 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbZKMCNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 21:13:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=NLyiqLsQtIcBuzo9egC22lEO2Om5dh6r9l07qn9qi6VUSYmFKQcde+rkyIaTF0MNYJ
         PV7TyrB3yXE91lqru8HIjilq3rFLczl0V+G7Pj7fmIoRjerXCsa5iS/lq3OtH5WqvRLW
         yMRu3syBNtn0OTOo8D7d1bwt+Nhw1SpSEXa5s=
Message-ID: <4AFCC0D4.9020708@gmail.com>
Date: Thu, 12 Nov 2009 20:13:40 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] libata: remove experimental tag on PATA drivers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the experimental tag on Parallel ATA drivers. Though some of the
individual PATA drivers are still marked as experimental, as a group they can
hardly be considered to be, given they've been used in various distros for some
time.

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index f2df6e2..33133c6 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig ATA
-	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
+	tristate "Serial ATA and Parallel ATA drivers"
 	depends on HAS_IOMEM
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
