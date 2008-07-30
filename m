Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYG3JCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYG3JCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYG3JCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:02:24 -0400
Received: from beru.its.uow.edu.au ([130.130.68.31]:42966 "EHLO
	beru.its.uow.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYG3JCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:02:23 -0400
X-Greylist: delayed 689 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2008 05:02:23 EDT
Subject: [patch 00/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Message-Id: <E1KO7OU-0007BT-Ff@wraith.cs.uow.edu.au>
From: mcs6502@gmail.com
Date: Wed, 30 Jul 2008 18:50:50 +1000
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following 31 patches attempt to bring pci_ids.h back into order.

patch-01-31: INTEL
patch-02-31: S2IO
patch-03-31: RDC
patch-04-31: ADDIDATA
patch-05-31: MELLANOX
patch-06-31: TIGON3
patch-07-31: TITAN
patch-08-31: SEALEVEL
patch-09-31: SIIG
patch-10-31: ITE
patch-11-31: ENSONIQ
patch-12-31: MARVELL
patch-13-31: SBE
patch-14-31: VIA
patch-15-31: NVIDIA
patch-16-31: CMD/SII
patch-17-31: QLOGIC
patch-18-31: YAMAHA
patch-19-31: MYLEX
patch-20-31: PROMISE
patch-21-31: HP
patch-22-31: SI
patch-23-31: MATROX
patch-24-31: TRIDENT
patch-25-31: AMD
patch-26-31: IBM
patch-27-31: DEC/COMPAQ
patch-28-31: NS
patch-29-31: LSI
patch-30-31: COMPAQ
patch-31-31: ESS

Note 1: I have not attempted a build with these changes. I have done
	a sort -u on both the original and fully patched files and there
	are only two lines that differ due to padding the ID number to
	4 digits.

544c544
< #define PCI_DEVICE_ID_COMPAQ_CISSC    0x46
---
> #define PCI_DEVICE_ID_COMPAQ_CISSC    0x0046
720c720
< #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL        0x252
---
> #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL        0x0252

Note 2:	I have not made any changes to the ATI section as this appears
	to be sorted into chip families.

Note 3:	I have not moved the following:

PCI_VENDOR_ID_TOSHIBA_2 (it is adjacent to PCI_VENDOR_ID_TOSHIBA)
PCI_DEVICE_ID_SEGA_BBA  (it seems to be missing a PCI_VENDOR_ID_SEGA line)
PCI_VENDOR_ID_ADDIDATA_OLD (it is adjacent to PCI_VENDOR_ID_ADDIDATA)
