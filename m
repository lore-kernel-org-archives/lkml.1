Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXLEAIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXLEAIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbXLEAIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:08:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:57807 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbXLEAIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:08:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HwAb3YYJXuFYcHthGT0YPz4qlFyd5WS1vTwI9YcPB4i26HWUyGd9OpxINcikK9j3TiHUl5Z/nc/VJMY82rM9vgsyADuuj4V95aO8WRR+XL7khQ+8/pO2jeDxOMBePc/Vtgf/MjspC8pgK8wKXGt56fgnWdhMoU7uQFcTrBYUjuU=
Message-ID: <cd32a0620712041608o7733db74xf4975dec44925730@mail.gmail.com>
Date: Wed, 5 Dec 2007 10:38:37 +1030
From: "Tom Lanyon" <tomlanyon@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Failure with SATA DVD-RW
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Just built a new machine with a Pioneer SATA DVD drive and linux
distro install CDs are not recognising it. The drive is connected to
the ICH9R southbridge of an Intel P35 chipset motherboard.

I can boot from the CD/DVD so the drive itself is working, but the
kernel reports the following:

scsi4: ahci
ata5: SATA link up at 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATAPI, max UDMA/66
ata5.00: qc timeout (cmd 0xef)
ata5.00: failed to set xfermode (err_mask=0x104)
ata5.00: limiting speed to UDMA/44
ata5: failed to recover some devices, retrying in 5 secs
ata5: port is slow to respond, please be patient (Status 0x80)
ata5: port failed to respond (30 secs, status 0x80)
ata5: COMRESET failed (device not ready)
ata5: hardreset failed, retrying in 5 secs
ata5: SATA link up at 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATAPI, max UDMA/66
ata5.00: qc timeout (cmd 0xef)
ata5.00: failed to set xfermode (err_mask=0x104)
ata5.00: limiting speed to PIO0
ata5: failed to recover some devices, retrying in 5 secs
ata5: port is slow to respond, please be patient (Status 0x80)
ata5: port failed to respond (30 secs, status 0x80)
ata5: COMRESET failed (device not ready)
ata5: hardreset failed, retrying in 5 secs
ata5.00: ATAPI, max UDMA/66
ata5.00: qc timeout (cmd 0xef)
ata5.00: failed to set xfermode (err_mask=0x104)
ata5.00: disabled

This is 2.6.19 (probably with a few distribution patches) on an
install CD. I also tried setting the SATA controller to a 'compatible
IDE' mode and the hard drives and DVD drive are detected and work
properly.

Any ideas what to try to get it working under AHCI?

-- 
Tom Lanyon
