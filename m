Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXEVO1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXEVO1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbXEVO0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:26:52 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:6702 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbXEVO0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:26:51 -0400
Date: Tue, 22 May 2007 08:25:59 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Enabling power states for Core 2 Duo
In-reply-to: <fa.ba5b6wvCJrj6u1+oZyC73ruruhQ@ifi.uio.no>
To: Paa Paa <paapaa125@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4652FD77.6090709@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ba5b6wvCJrj6u1+oZyC73ruruhQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paa Paa wrote:
> For some reason I'm not able to enable processor power states (c1, c2 
> etc.) for my Core 2 Duo. This is what I get::
> 
> cat /proc/acpi/processor/CPU1/info
> processor id:            0
> acpi id:                 1
> bus mastering control:   no
> power management:        no
> throttling control:      no
> limit interface:         no
> 
> cat /proc/acpi/processor/CPU1/power
> active state:            C0
> max_cstate:              C8
> bus master activity:     00000000
> maximum allowed latency: 2000 usec
> states:
> 
> "dmesg | grep -i power" also gives nothing. I have ACPI enabled in BIOS 
> and in kernel I have these set ("grep -i acpi .config | grep =y"):
> 
> CONFIG_ACPI=y
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_THERMAL=y
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_ACPI_CPUFREQ=y
> CONFIG_PNPACPI=y
> CONFIG_SATA_ACPI=y
> 
> I'm probably missing something crucial here. So how do I enable power 
> states? I'm using 64-bit Gentoo. My mobo is Asus P5B Deluxe. Otherwise 
> ACPI works fine.

The BIOS has to expose this support in ACPI, if it doesn't (which is 
often the case on desktop boards) you won't get any C-state support 
(well, except for C1 which is just the normal halt state).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

