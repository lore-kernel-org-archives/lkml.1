Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbXEILQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbXEILQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXEILQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:16:12 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:37743 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180AbXEILPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:15:20 -0400
X-BigFish: V
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-7"
Content-Transfer-Encoding: 7bit
Subject: =?utf-7?B?K0FGcy1wYXRjaCtBRjAtIEFkZCB0aGUgZGV2aWNlIElEcyBmb3IgQQ==?=
	=?utf-7?B?TUQvQVRJIFNCNzAw?=
Date: Wed, 9 May 2007 19:15:12 +0800
Message-ID: <FFECF24D2A7F6D418B9511AF6F3586020197F6A6@shacnexch2.atitech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: =?utf-7?B?K0FGcy1wYXRjaCtBRjAtIEFkZCB0aGUgZGV2aWNlIElEcyBmb3IgQQ==?=
	=?utf-7?B?TUQvQVRJIFNCNzAw?=
Thread-Index: =?utf-7?B?QWNlU0sxQUVGZnZkOFNjYVEyYVFSMmdDeUN4aEF3K0FEMEFQUS0=?=
From: "Henry Su" <henry.su@amd.com>
To: <alan@lxorguk.ukuu.org.uk>
Cc: <greg@kroah.com>, <bzolnier@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>, <xiaosuzi520@hotmail.com>
X-OriginalArrivalTime: 09 May 2007 11:15:16.0448 (UTC) FILETIME=[523F5600:01C7922B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: henry.su+AEA-amd.com
Adding the device ID for AMD/ATI SB700.
Signed-off-by:henry su +ADw-henry.su+AEA-amd.com+AD4-
------------------------------------------
--- linux-2.6.21.1.orig/include/linux/pci+AF8-ids.h	2007-05-10 06:30:23.000000000 +-0800
+-+-+- linux-2.6.21.1/include/linux/pci+AF8-ids.h	2007-05-10 07:10:18.000000000 +-0800
+AEAAQA- -371,6 +-371,9 +AEAAQA-
 +ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-SRAID	0x4381
 +ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-SMBUS	0x4385
 +ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-IDE	0x438c
+-+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-SATA	0x4390
+-+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-SMBUS	0x4395
+-+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-IDE	0x439c
 
 +ACM-define PCI+AF8-VENDOR+AF8-ID+AF8-VLSI		0x1004
 +ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-VLSI+AF8-82C592	0x0005

--- linux-2.6.21.1.orig/drivers/i2c/busses/i2c-piix4.c	2007-05-10 06:30:14.000000000 +-0800
+-+-+- linux-2.6.21.1/drivers/i2c/busses/i2c-piix4.c	2007-05-10 07:14:06.000000000 +-0800
+AEAAQA- -399,6 +-399,8 +AEAAQA- static struct pci+AF8-device+AF8-id piix4+AF8-ids+AFsAXQ- 
 	  .driver+AF8-data +AD0- 0 +AH0-,
 	+AHs- PCI+AF8-DEVICE(PCI+AF8-VENDOR+AF8-ID+AF8-ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-SMBUS),
 	  .driver+AF8-data +AD0- 0 +AH0-,
+-	+AHs- PCI+AF8-DEVICE(PCI+AF8-VENDOR+AF8-ID+AF8-ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-SMBUS),
+-	  .driver+AF8-data +AD0- 0 +AH0-,
 	+AHs- PCI+AF8-DEVICE(PCI+AF8-VENDOR+AF8-ID+AF8-SERVERWORKS, PCI+AF8-DEVICE+AF8-ID+AF8-SERVERWORKS+AF8-OSB4),
 	  .driver+AF8-data +AD0- 0 +AH0-,
 	+AHs- PCI+AF8-DEVICE(PCI+AF8-VENDOR+AF8-ID+AF8-SERVERWORKS, PCI+AF8-DEVICE+AF8-ID+AF8-SERVERWORKS+AF8-CSB5),
--- linux-2.6.21.1.orig/drivers/ata/pata+AF8-atiixp.c	2007-05-10 06:30:14.000000000 +-0800
+-+-+- linux-2.6.21.1/drivers/ata/pata+AF8-atiixp.c	2007-05-10 07:17:07.000000000 +-0800
+AEAAQA- -283,6 +-283,7 +AEAAQA- static const struct pci+AF8-device+AF8-id atiixp
 	+AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP300+AF8-IDE), +AH0-,
 	+AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP400+AF8-IDE), +AH0-,
 	+AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-IDE), +AH0-,
+-	+AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-IDE), +AH0-,
 
 	+AHs- +AH0-,
 +AH0AOw-

--- linux-2.6.21.1.orig/drivers/ide/pci/atiixp.c	2007-05-10 06:30:17.000000000 +-0800
+-+-+- linux-2.6.21.1/drivers/ide/pci/atiixp.c	2007-05-10 07:18:39.000000000 +-0800
+AEAAQA- -353,6 +-353,7 +AEAAQA- static struct pci+AF8-device+AF8-id atiixp+AF8-pci+AF8-t
 	+AHs- PCI+AF8-VENDOR+AF8-ID+AF8-ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP300+AF8-IDE, PCI+AF8-ANY+AF8-ID, PCI+AF8-ANY+AF8-ID, 0, 0, 0+AH0-,
 	+AHs- PCI+AF8-VENDOR+AF8-ID+AF8-ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP400+AF8-IDE, PCI+AF8-ANY+AF8-ID, PCI+AF8-ANY+AF8-ID, 0, 0, 0+AH0-,
 	+AHs- PCI+AF8-VENDOR+AF8-ID+AF8-ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-IDE, PCI+AF8-ANY+AF8-ID, PCI+AF8-ANY+AF8-ID, 0, 0, 1+AH0-,
+-	+AHs- PCI+AF8-VENDOR+AF8-ID+AF8-ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-IDE, PCI+AF8-ANY+AF8-ID, 
+-PCI+AF8-ANY+AF8-ID, 0, 0, 1+AH0-,
 	+AHs- 0, +AH0-,
 +AH0AOw-
 MODULE+AF8-DEVICE+AF8-TABLE(pci, atiixp+AF8-pci+AF8-tbl)+ADs-

--- linux-2.6.21.1.orig/drivers/ata/ahci.c	2007-05-10 06:30:14.000000000 +-0800
+-+-+- linux-2.6.21.1/drivers/ata/ahci.c	2007-05-10 07:41:41.000000000 +-0800
+AEAAQA- -415,6 +-415,7 +AEAAQA- static const struct pci+AF8-device+AF8-id ahci+AF8-p
 	/+ACo- ATI +ACo-/
 	+AHs- PCI+AF8-VDEVICE(ATI, 0x4380), board+AF8-ahci+AF8-sb600 +AH0-, /+ACo- ATI SB600 non-raid +ACo-/
 	+AHs- PCI+AF8-VDEVICE(ATI, 0x4381), board+AF8-ahci +AH0-, /+ACo- ATI SB600 raid +ACo-/
+-	+AHs- PCI+AF8-VDEVICE(ATI, 0x4390), board+AF8-ahci+AF8-sb600 +AH0-, /+ACo- ATI SB700 +ACo-/
 
 	/+ACo- VIA +ACo-/
 	+AHs- PCI+AF8-VDEVICE(VIA, 0x3349), board+AF8-ahci+AF8-vt8251 +AH0-, /+ACo- VIA VT8251 +ACo-/

--- linux-2.6.21.1.orig/drivers/pci/quirks.c	2007-05-10 06:30:17.000000000 +-0800
+-+-+- linux-2.6.21.1/drivers/pci/quirks.c	2007-05-10 07:49:33.000000000 +-0800
+AEAAQA- -875,6 +-875,7 +AEAAQA- static void +AF8AXw-devinit quirk+AF8-sb600+AF8-sata(s
 	+AH0-
 +AH0-
 DECLARE+AF8-PCI+AF8-FIXUP+AF8-HEADER(PCI+AF8-VENDOR+AF8-ID+AF8-ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-SATA, quirk+AF8-sb600+AF8-sata)+ADs-
+-DECLARE+AF8-PCI+AF8-FIXUP+AF8-HEADER(PCI+AF8-VENDOR+AF8-ID+AF8-ATI, 
+-PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-SATA, quirk+AF8-sb600+AF8-sata)+ADs-
 
 /+ACo-
  +ACo-	Serverworks CSB5 IDE does not fully support native mode


