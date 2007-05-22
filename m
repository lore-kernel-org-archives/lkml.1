Return-Path: <linux-kernel-owner+w=401wt.eu-S1765994AbXEVM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765994AbXEVM7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbXEVM7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:59:15 -0400
Received: from bay0-omc2-s5.bay0.hotmail.com ([65.54.246.141]:41932 "EHLO
	bay0-omc2-s5.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757822AbXEVM7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:59:13 -0400
Message-ID: <BAY20-F799F70E388FD1C990B15FF9360@phx.gbl>
X-Originating-IP: [88.112.28.249]
X-Originating-Email: [paapaa125@hotmail.com]
From: "Paa Paa" <paapaa125@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: Enabling power states for Core 2 Duo
Date: Tue, 22 May 2007 12:59:11 +0000
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
X-OriginalArrivalTime: 22 May 2007 12:59:12.0565 (UTC) FILETIME=[FEA20650:01C79C70]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason I'm not able to enable processor power states (c1, c2 etc.) 
for my Core 2 Duo. This is what I get::

cat /proc/acpi/processor/CPU1/info
processor id:            0
acpi id:                 1
bus mastering control:   no
power management:        no
throttling control:      no
limit interface:         no

cat /proc/acpi/processor/CPU1/power
active state:            C0
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 2000 usec
states:

"dmesg | grep -i power" also gives nothing. I have ACPI enabled in BIOS and 
in kernel I have these set ("grep -i acpi .config | grep =y"):

CONFIG_ACPI=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_PNPACPI=y
CONFIG_SATA_ACPI=y

I'm probably missing something crucial here. So how do I enable power 
states? I'm using 64-bit Gentoo. My mobo is Asus P5B Deluxe. Otherwise ACPI 
works fine.

_________________________________________________________________
FREE pop-up blocking with the new MSN Toolbar - get it now! 
http://toolbar.msn.click-url.com/go/onm00200415ave/direct/01/

