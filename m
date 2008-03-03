Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYCCRGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYCCRGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYCCRGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:06:12 -0500
Received: from spirit.analogic.com ([204.178.40.4]:4475 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbYCCRGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:06:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 03 Mar 2008 17:06:09.0434 (UTC) FILETIME=[E0514FA0:01C87D50]
Content-class: urn:content-classes:message
Subject: 64-bit AMD panic
Date: Mon, 3 Mar 2008 12:06:09 -0500
Message-ID: <Pine.LNX.4.61.0803031205030.5874@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 64-bit AMD panic
Thread-Index: Ach9UOBySjQtQqJdQf2SNMXqblUU+A==
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello all,

We have 64-bit production machines that use the kernel shipped with
a RedHat distribution, linux-2.6.11-1.1369_FC4smp. There have been
no problems until we received recent hardware. With the latest hardware,
which the vendor claims hasn't changed, the machines panic when either
a USB mouse or USB keyboard are plugged in.

Machine:

Supermicro H8DME-2
Two quad-Core AMD Opteron CPUs
64GB DDR2 400 SDRAM
6 SATA2 3.0Gb/s HD Support
2 64-bit 133/100 MHz PCI-X
2 64=bit 100MHz PCI-X
ATI ES1000 Graphics

Chipset nVida MCP55 Pro
NEC uPD720400
USB FUCI, uses ohci_hcd driver.

When mouse or keyboard is inserted, I get a panic with:
"map_single bounce buffer is not DMA'ble."

This comes from: linux-2.6.11-prep/arch/ia64/lib/swiotlb.c,
line 440. I added 64-bit long print hex to the panic statement
so I could display the address it doesn't like.

The address it doesn't like is: 0x000000022a0aa000

Does anybody have a clue what might be the matter and how to fix it?

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
