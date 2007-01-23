Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbXAWQvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbXAWQvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 11:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932911AbXAWQvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 11:51:46 -0500
Received: from i9.amg.net.pl ([195.117.14.9]:4446 "EHLO smtp.amg.net.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932899AbXAWQvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 11:51:45 -0500
Date: Tue, 23 Jan 2007 17:51:43 +0100
From: areq@areq.eu.org
To: linux-kernel@vger.kernel.org
Subject: SAS1068 PCI-X Fusion-MPT SAS 1000:0055
Message-ID: <20070123165143.GA10423@areq.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have new NEC server with SAS1068 PCI-X Fusion-MPT SAS
pciid: 1000:0055
mptsas form 2.6.20-rc5 don't recognize it ;(

I see that driver support only 1000:0054 and 1000:0058 devices.

./drivers/message/fusion/mptsas.c:      { PCI_VENDOR_ID_LSI_LOGIC,
MPI_MANUFACTPAGE_DEVID_SAS1068,
./drivers/message/fusion/mptsas.c:      { PCI_VENDOR_ID_LSI_LOGIC,
MPI_MANUFACTPAGE_DEVID_SAS1068E,
./drivers/message/fusion/mptbase.c:     else if (pdev->device ==
MPI_MANUFACTPAGE_DEVID_SAS1068) {
./drivers/message/fusion/mptbase.c:     else if (pdev->device ==
MPI_MANUFACTPAGE_DEVID_SAS1068E) {
./drivers/message/fusion/lsi/mpi_cnfg.h:#define
MPI_MANUFACTPAGE_DEVID_SAS1068              (0x0054)
./drivers/message/fusion/lsi/mpi_cnfg.h:#define
MPI_MANUFACTPAGE_DEVID_SAS1068E             (0x0058)

lspci -v:

0d:05.0 SCSI storage controller: LSI Logic / Symbios Logic Unknown
device 0055 (rev 01)
	Subsystem: NEC Corporation Unknown device 8336
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 7
	I/O ports at 3000 [size=256]
	Memory at deb10000 (64-bit, non-prefetchable) [size=16K]
	Memory at deb00000 (64-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at 88000000 [disabled] [size=2M]
	Capabilities: [50] Power Management version 2
	Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
	Capabilities: [68] PCI-X non-bridge device
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1


Any solution ?

Cheers,
Areq
