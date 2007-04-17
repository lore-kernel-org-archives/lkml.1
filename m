Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbXDQMQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbXDQMQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 08:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXDQMQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 08:16:31 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37044 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbXDQMQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 08:16:30 -0400
Date: Tue, 17 Apr 2007 14:16:25 +0200 (MEST)
Message-Id: <200704171216.l3HCGPxv017629@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [BUG 2.6.21-rc7] acpi_pm clocksource loses time on x86-64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The machine is an old Athlon64 laptop (Targa Visionary 811,
OEMd as the Arima W720-K8, also sold as the eMachines m6805)
with a VIA K8T800 chipset. ACPI is enabled.

Up to kernel 2.6.20, time-keeping worked fine. In the
x86-64 kernel, the clock source is listed as "jiffies".

With current 2.6.21-rc7, the x86-64 kernel selects
acpi_pm as its clock source. Unfortunately, with this
clock time drifts and it loses several minutes per hour.

What's strange is that the i386 kernel on the same
machine (with similar .config) does not lose time
while using the acpi_pm clock source.

There are no messages in dmesg to suggest that the
kernel has detected any problems with acpi_pm.

/Mikael
