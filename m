Return-Path: <linux-kernel-owner+w=401wt.eu-S933302AbXIBPn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbXIBPn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXIBPnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:43:51 -0400
Received: from mail02.o2online.de ([82.113.101.28]:54846 "EHLO
	mail.mc.o2online.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755081AbXIBPnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:43:50 -0400
X-Greylist: delayed 3733 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2007 11:43:49 EDT
Date: Sun, 2 Sep 2007 16:41:32 +0200 (CEST)
Message-Id: <200709021441.l82EfWCe022642@mail.mc.o2online.de>
From: <colin.michael@o2online.de>
To: <linux-kernel@vger.kernel.org>
Subject: [patch] enable userspace cpu core voltage control with acpi-cpufreq
X-Priority: 3 (Normal)
Importance: Normal
MIME-Version: 1.0
X-Mailer: O3SIS o2 Communication Center Mail 5.26.00 2003-09-04 Cologne Edition
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

please add me as CC to any answear to that post.


Hello, 
i want to make a patch known that provides a userspace interface to control the core voltage of a computer processor(s).

Some notes about:
=============================================================
The current version patches acpi-cpufreq.
An older version patched speedstep-centrino and also adds additional built-in frequency/voltage tables to the Linux kernel 
for some Pentium-M CPU models.
This is particularly usefull for laptops with broken ACPI that can't use the speedstep-centrino cpufreq driver at all.

The interface is located in SysFS. Some files are read only (for example to read the default values), others
are writeable to set up lower voltages.

The main use of this interface is to lower the core voltage of a laptop's CPU ("undervolt").
The goal is to reduce the laptop's temperature so the cooling fan can safely run at a slower speed. 
Another goal of undervolting is to reduce the power consumption of a laptop and thus extend its battery lifetime.

Currently supported processors are Pentium-M (centrino) class CPUs and Core/Core2 CPUs.
Supporting AMD processors is planned and a patch may be available at the end of this year.



An example about the benefits:
=============================================================
My Core2Duo T7200 normally uses 1.2Volt at 2GHz.
The power consumption (measured with intel's PowerTOP) of the system is ~55 Watts at full load (using sprime).

The lowest Voltage i can use without instabilizing the system is 0.9875Volts at 2GHz.
Using this setting the power consumption is reduced to ~40 Watts.

Also the CPU stay cooler depending on the load and speed.


Many peoples with Pentium-M processors reporting they can run the cpu at 0.700Volts. For most of them the CPU fan
never brushes during normal work (also depenting on the load and the system).

=============================================================
Unfortunalely the projects suffers on to few developers.
So if you think this would be interesting you you are welcome to join.

Project located at: https://www.dedigentoo.org/trac/linux-phc/
IRC on freenode: ##linux-phc

Regards
cmichael   c dot michael -at- o2online dot de


