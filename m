Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbYL3M0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbYL3M0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYL3MZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:25:44 -0500
Received: from lucidpixels.com ([75.144.35.66]:48182 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbYL3MZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:25:43 -0500
Date: Tue, 30 Dec 2008 07:25:42 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: 2.6.28: How come some kernel options cannot be disabled for non-existent
 hardware?
Message-ID: <alpine.DEB.1.10.0812300641390.11356@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example:

-> ACPI (Advanced Configuration and Power Interface) Support
-> -*-   Dock

>From dmesg:
[    0.247210] ACPI: EC: Look up EC in DSDT
[    0.249987] ACPI: Interpreter enabled
[    0.249990] ACPI: (supports S0 S5)
[    0.250005] ACPI: Using IOAPIC for interrupt routing
[    0.254621] ACPI: No dock devices found.
[    0.254631] ACPI: PCI Root Bridge [PCI0] (0000:00)

I have no Docking bay on my desktop machine, even when I change:
CONFIG_ACPI_DOCK=y
to
CONFIG_ACPI_DOCK=n

It still shows up as enabled and it is in dmesg shown above.  How come 
some kernel options are enabled and cannot (easily?) be disabled for 
hardware that does not exist in my machine?

http://home.comcast.net/~jpiszcz/20081230/config-2.6.28.txt

Justin.
