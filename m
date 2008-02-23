Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbYBWOJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbYBWOJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758951AbYBWOGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:06:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:35830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758930AbYBWOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=r0LN1XyQFIcZBYH3fYk+vs3LmE4e8gDHEpXdpZO45+wi+UV4JjJpxKr2ej3jARHBZq6+XsFbVejevNu6SHYre7LPomJWmxiQF5lFyQ9RhVY4pP/cN7qbbIJJH9TgpbBmryYw/4qj8n2ZBoYYXzIjnG9FptmaqvdW4qK3hcXlss4=
Date: Sat, 23 Feb 2008 15:05:56 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 09/10] IDE: Coding Style fixes to drivers/ide/pci/jmicron.c
Message-ID: <20080223150556.1e55cbbd@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/pci/jmicron.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index 440266f..673f7dc 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -63,8 +63,7 @@ static u8 __devinit ata66_jmicron(ide_hwif_t *hwif)
 	 *	actually do our cable checking etc. Thankfully we don't need
 	 *	to do the plumbing for other cases.
 	 */
-	switch (port_map[port])
-	{
+	switch (port_map[port]) {
 	case PORT_PATA0:
 		if (control & (1 << 3))	/* 40/80 pin primary */
 			return ATA_CBL_PATA40;
-- 
1.5.4.2.316.gf7a7

