Return-Path: <linux-kernel-owner+w=401wt.eu-S934896AbYEIBUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934896AbYEIBUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYEIBUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:20:37 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:58453 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbYEIBUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:20:36 -0400
Message-ID: <4823A6DA.8010502@googlemail.com>
Date: Fri, 09 May 2008 03:20:26 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: linux-next: ACPI I/O resource conflicts warning
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all ,

I've noticed on linux-next from today the following ACPI warning:

...

[4294023.308622] ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
[4294023.308622] ACPI: I/O resource  [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
[4294023.316478] ACPI: Device needs an ACPI driver

...

dsdt.dsl from my motherboard can be found there:

http://frugalware.org/~crazy/ASUS_P5E-VM_DO/dsdt.dsl

full dmesg:

http://frugalware.org/~crazy/dmesg/DMAR/dmesg

Please let me know if you need more infos.

Best Regards,

Gabriel C
