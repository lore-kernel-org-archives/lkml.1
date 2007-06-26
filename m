Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbXFZSa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbXFZSa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXFZSaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:30:19 -0400
Received: from main.gmane.org ([80.91.229.2]:54321 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362AbXFZSaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:30:17 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: [2.6.22-rc6] NForce4 soft and hard resetting ports and exceptions
Date: Tue, 26 Jun 2007 17:45:22 +0000 (UTC)
Message-ID: <pan.2007.06.26.17.45.21@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: d54c1e7e8.access.telenet.be
User-Agent: Pan/0.131 (Ghosts: First Variation)
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tried Linux 2.6.22-rc6 on my machine with an Asus A8N-SlI Deluxe 
motherboard (NForce 4 chipset).

When booting, the system hangs for a long time, but it continues after a 
long wait. I found these kind of errors in the logs afterwards:

ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
         res 50/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ata2.00: revalidation failed (errno=-2)
ata2: failed to recover some devices, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ata_hpa_resize 1: sectors = 390721968, hpa_sectors = 390721968
ata2.00: ata_hpa_resize 1: sectors = 390721968, hpa_sectors = 390721968
ata2.00: configured for UDMA/133
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
         res 50/00:00:af:f1:49/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ATA: abnormal status 0xD0 on port 0xffffc2000001a59c
ata2.00: revalidation failed (errno=-2)
[...]

With Linux 2.6.21 this did not happen.

config, dmesg and lspci can be found here:
http://artipc10.vub.ac.be/kernelbug/

-- 
Frederik Himpe

