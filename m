Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYDSBz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYDSBz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 21:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYDSBzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 21:55:47 -0400
Received: from rv-out-0708.google.com ([209.85.198.251]:50341 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751788AbYDSBzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 21:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LjXQXd/NVKFVrqJQPv/edB6OCA1Sgjjyh5nOdIbOvHwr86whCnbTBuDh3V+Zqt6eXLJWyYXJwcZmNHSmrs9k6++sb/UnTUWQzr/cyx0oFNiQAB7eQT39W6YH3/rOnbE0LalqccysT4mq497z0s7ailaJ+IcPuSaCBj1CTOeoxi4=
Message-ID: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
Date: Fri, 18 Apr 2008 18:55:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: Mark_Salyzyn@adaptec.com, James.Bottomley@hansenpartnership.com
Subject: aacraid broken in git
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
