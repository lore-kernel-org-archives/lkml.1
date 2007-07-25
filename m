Return-Path: <linux-kernel-owner+w=401wt.eu-S1765545AbXGYOqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765545AbXGYOqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXGYOqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:46:04 -0400
Received: from www.comattitude.fr ([91.121.13.180]:4044 "EHLO
	mail2.comattitude.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754712AbXGYOqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:46:03 -0400
X-Greylist: delayed 1624 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2007 10:46:03 EDT
Message-ID: <46A75BD1.5090402@wanadoo.fr>
Date: Wed, 25 Jul 2007 16:18:57 +0200
From: =?ISO-8859-1?Q?S=E9bastien_CRAMATTE?= <s.cramatte@wanadoo.fr>
Organization: Zen Soluciones
User-Agent: Thunderbird 2.0.0.5 (Macintosh/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Marvell 88SE6121 with patched pata_marvell still doesn't works 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I've got an MSI P35 motherboard with
4 SATAs ports via ICH9R southbridge chipset and 1 SATA and IDE via
Marvell 88SE6121

In bios, It's possible to set ICH9 in  RAID, AHCI or IDE mode but  not
Marvell chipset

I've applied the patch bellow against a 2.6.20 kernel

http://marc.info/?l=linux-kernel&m=116808637400504&w=2

In dmesg I've got this kind of line

ATA: abnormal status 0x7F on port 0xE807

I've got a 320Gb HD and  DVD burner plugged on the IDE connector.

Does anyone  know how can solve this ?
Normally I should use a 2.6.22 kernel to have support for hardware
monitoring  and cpucore driver.

Regards
