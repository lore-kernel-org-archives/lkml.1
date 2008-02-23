Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbYBWRsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbYBWRsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYBWRsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:48:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:36115 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYBWRsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:48:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jKQlaQz9g6A9mKIqBTejjE8KDBw8zhmFqWQ4jkWrVbraR/NVmCK9im0OsSzvW60EoeSRgpxibTSMuG87X/potSPn8aejYbmwacPaQeGIb/3C3wyUaNnF+oEd4PTZE4ry+iMW7QU7NEt0cIrpJe5V9jEa5PcYhew++Y5A8aWxblA=
Message-ID: <19f34abd0802230948n3b98b7d2kd67ca9c2f8fbbd47@mail.gmail.com>
Date: Sat, 23 Feb 2008 18:48:10 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jeff Garzik" <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am experiencing a strange problem with 2.6.23.15-137.fc8 (Fedora 8)
kernel. Everything works fine, but if I provide the "nosmp" option to
the kernel, I get some (S)ATA errors and the system does not boot.

Here is a screenshot:
http://folk.uio.no/vegardno/DSCF2543.JPG

Handwritten summary:
scsi0 : ahci
scsi1 : ahci
ata1: SATA max UDMA/133 cmd 0xf884c100 ctl 0x00000000 bmdma 0x000...
ata2: SATA max UDMA/133 cmd 0xf884c180 ctl 0x00000000 bmdma 0x000...
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: port is slow to respond, please be patient (Status 0x80)
ata1: COMRESET failed (errno=-16)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
...

I don't see the connection between (no-)smp and ata. Something with
interrupt routing/IPI, missing irq ack? Booting another !SMP kernel
works fine. The problem also exists in 2.6.24-rc2.


Kind regards,
Vegard Nossum
