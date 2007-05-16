Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbXEPGyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbXEPGyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbXEPGx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:53:56 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:21418 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643AbXEPGxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:53:55 -0400
X-BigFish: V
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-7"
Content-Transfer-Encoding: 7bit
Subject: =?utf-7?B?K0FGcy1QQVRDSCA0LzQrQUYwLSBBZGQgdGhlIGNvbWJpbmVkIG1vZA==?=
	=?utf-7?B?ZSBmb3IgQVRJIFNCNzAw?=
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Wed, 16 May 2007 14:53:46 +0800
Message-ID: <FFECF24D2A7F6D418B9511AF6F35860201A4D662@shacnexch2.atitech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: =?utf-7?B?K0FGcy1QQVRDSCA0LzQrQUYwLSBBZGQgdGhlIGNvbWJpbmVkIG1vZA==?=
	=?utf-7?B?ZSBmb3IgQVRJIFNCNzAw?=
Thread-Index: AceXhvNP2/mIJpxKSA
From: "Henry Su" <henry.su@amd.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>, <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>,
       =?utf-7?B?Z21haWwrQUY4LWF0aQ==?= <henry.su.ati@gmail.com>
X-OriginalArrivalTime: 16 May 2007 06:53:50.0625 (UTC) FILETIME=[F5A8F110:01C79786]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: henry.su+AEA-amd.com
Besides those modes in ATI SB600 SATA controller, ATI SB700 supports one more mode:the combined mode.

The combined mode is a Legacy IDE mode used for compatibility with some old OS without AHCI driver, 
but now it is not necessary for Linux since the kernel has supported AHCI.
Signed-off-by: Luugi Marsan +ADw-luugi.marsan+AEA-amd.com+AD4-
-----------------------------------------------------
diff -Nur linux-2.6.21.1.orig/include/linux/pci+AF8-ids.h linux-2.6.21.1/include/linux/pci+AF8-ids.h
--- linux-2.6.21.1.orig/include/linux/pci+AF8-ids.h 2007-05-16 13:28:54.405386000 +-0800
+-+-+- linux-2.6.21.1/include/linux/pci+AF8-ids.h      2007-05-16 13:45:29.936636000 +-0800
+AEAAQA- -371,6 +-371,9 +AEAAQA-
 +ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-SRAID 0x4381
 +ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-SMBUS 0x4385
 +ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-IDE   0x438c
+-+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-SATA  0x4390
+-+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-SMBUS 0x4395
+-+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-IDE   0x439c

 +ACM-define PCI+AF8-VENDOR+AF8-ID+AF8-VLSI             0x1004
 +ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-VLSI+AF8-82C592      0x0005

diff -Nur linux-2.6.21.1.orig/drivers/pci/quirks.c linux-2.6.21.1/drivers/pci/quirks.c
--- linux-2.6.21.1.orig/drivers/pci/quirks.c    2007-05-16 13:28:09.702261000 +-0800
+-+-+- linux-2.6.21.1/drivers/pci/quirks.c 2007-05-16 13:41:26.155386000 +-0800
+AEAAQA- -875,6 +-875,7 +AEAAQA-
        +AH0-
 +AH0-
 DECLARE+AF8-PCI+AF8-FIXUP+AF8-HEADER(PCI+AF8-VENDOR+AF8-ID+AF8-ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-SATA, quirk+AF8-sb600+AF8-sata)+ADs-
+-DECLARE+AF8-PCI+AF8-FIXUP+AF8-HEADER(PCI+AF8-VENDOR+AF8-ID+AF8-ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-SATA, quirk+AF8-sb600+AF8-sata)+ADs-

 /+ACo-
  +ACo-     Serverworks CSB5 IDE does not fully support native mode

