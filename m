Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbXJXPfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbXJXPfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbXJXPfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:35:12 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:41680 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbXJXPfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:35:11 -0400
Message-ID: <471F662E.9090502@free.fr>
Date: Wed, 24 Oct 2007 17:35:10 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
CC: len.brown@intel.com, robert.moore@intel.com
Subject: Re: halt and poweroff do not shut the system down
References: <471EFF90.5070606@free.fr>
In-Reply-To: <471EFF90.5070606@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> When I run 'halt' or 'poweroff' (sysvinit-2.86) the kernel prints:
> 
> Halting.
> Shutdown: hdc
> ACPI: PCI interrupt for device 0000:01:05.0 disabled
> ACPI: PCI interrupt for device 0000:01:04.0 disabled
> ACPI: PCI interrupt for device 0000:01:03.0 disabled
> ACPI: PCI interrupt for device 0000:01:02.0 disabled
> Power down.
> acpi_power_off called
> 
> But the system does not shut down. (The fans keep spinning, the LEDs
> keep shining, the integrated LCD keeps displaying.) Basically, the
> motherboard is still providing power to every component, as if the
> power supply had refused to stop.

I noticed the following message at boot:

* The chipset may have PM-Timer Bug. Due to workarounds for a bug,
* this clock source is slow. If you are sure your timer does not have
* this bug, please use "acpi_pm_good" to disable the workaround

Is there any chance that the two issues are connected?
(It seems very unlikely.)

How can I tell whether the bug is fixed in my south bridge or not?
http://linux.kernel.free.fr/halt/lspci.txt

Regards.
