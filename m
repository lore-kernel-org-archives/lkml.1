Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYDSJEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYDSJEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 05:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYDSJEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 05:04:21 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:32786 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYDSJEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 05:04:20 -0400
Date: Sat, 19 Apr 2008 11:04:17 +0200
Message-Id: <245566938@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re:aacraid broken in git
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+KzBrFutuiQVfqaV9jhyBW7rezO/6ZWN27trTqqjoGMaTLI
 MOoU+ChWTOKzfwr0iXpaEVYX2ho24FZtzoXrv6St3c7p6olRkM=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

what was the last working kernel for you?
any chance to bisect ?


List:       linux-scsi
Subject:    aacraid broken in git
From:       "Yinghai Lu" <yhlu.kernel () gmail ! com>
Date:       2008-04-19 1:55:42
Message-ID: 86802c440804181855t615a5616g62d083695ca8ea08 () mail ! gmail ! com
[Download message RAW]

4/18 2.6-git got

Calling initcall 0xffffffff80f10f97: aac_init+0x0/0x95()
Adaptec aacraid driver 1.1-5[2455]-ms
ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNEB] -> GSI 18 (level, low) -> IRQ
 18
PCI: Enabling bus mastering for device 0000:04:00.0
PCI: Setting latency timer of device 0000:04:00.0 to 64
AAC0: kernel 5.2-0[15594]
AAC0: monitor 5.2-0[15594]
AAC0: bios 5.2-0[15594]
AAC0: serial AA0009
AAC0: Non-DASD support enabled.
AAC0: 64bit support enabled.
AAC0: 64 Bit DAC enabled
aac_fib_free, XferState != 0, fibptr = 0xffff8108232e0000, XferState = 0x810ad
ACPI: PCI interrupt for device 0000:04:00.0 disabled
aacraid: probe of 0000:04:00.0 failed with error -4
initcall 0xffffffff80f10f97: aac_init+0x0/0x95() returned 0.
initcall 0xffffffff80f10f97 ran for 286 msecs: aac_init+0x0/0x95()


Linux LBSuse 2.6.25-x86-latest.git-01659-g1f8551e #106 SMP Fri Apr 18
18:24:39 PDT 2008 x86_64 x86_64 x86_64 GNU/Linux

YH

______________________________________________________
Bis 50 MB Dateianhänge? Kein Problem!
http://freemail.web.de/club/landingpage.htm/?mc=025556

