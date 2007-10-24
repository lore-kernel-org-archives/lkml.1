Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXJXIRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXJXIRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXJXIRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:17:23 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:46782 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXJXIRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:17:21 -0400
Message-ID: <471EFF90.5070606@free.fr>
Date: Wed, 24 Oct 2007 10:17:20 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
CC: len.brown@intel.com, robert.moore@intel.com
Subject: halt and poweroff do not shut the system down
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I run 'halt' or 'poweroff' (sysvinit-2.86) the kernel prints:

Halting.
Shutdown: hdc
ACPI: PCI interrupt for device 0000:01:05.0 disabled
ACPI: PCI interrupt for device 0000:01:04.0 disabled
ACPI: PCI interrupt for device 0000:01:03.0 disabled
ACPI: PCI interrupt for device 0000:01:02.0 disabled
Power down.
acpi_power_off called

But the system does not shut down. (The fans keep spinning, the LEDs
keep shining, the integrated LCD keeps displaying.) Basically, the 
motherboard is still providing power to every component, as if the power 
supply had refused to stop.

I followed the instructions given here:
http://bugzilla.kernel.org/show_bug.cgi?id=6431

cf. http://bugzilla.kernel.org/show_bug.cgi?id=9148

The system is an FWA-3140-CE:
http://advantech.com/products/1U-Rackmount-Intel-Pentium-4Processor-based-Platform-with-4PCI-LAN-Ports-2-PCI-Expansion-Slots/mod_1-23A2W4.aspx

The manufacturer is unwilling to help because they don't support Linux, 
and claim it is a software issue. I will ask them whether Windows is 
able to properly shut the system down.

What can I do to help fix the problem?

Regards.

