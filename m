Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYFVArU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYFVArU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 20:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYFVArJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 20:47:09 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:54145 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYFVArI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 20:47:08 -0400
Message-ID: <485DA11C.7050906@keyaccess.nl>
Date: Sun, 22 Jun 2008 02:47:24 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: LMSENSORS: 2.6.26-rc, enabling ACPI Termal Zone support costs sensors
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

On 2.6.26-rc and perhaps earlier, when I enable the ACPI Thermal Zone 
support (CONFIG_ACPI_THERMAL) I see in dmesg:

ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (56 C)

My /sys/class/hwmon/hwmon0 (a W83782D chip) becomes hwmon1, there's a 
new /sys/class/hwmon/hwmon0 and "sensors -s" craps out with:

# sensors -s
Can't access procfs/sysfs file
Kernel interface access error
For 2.6 kernels, make sure you have mounted sysfs and libsensors
was compiled with sysfs support!

# sensors --version
sensors version 2.10.6 with libsensors version 2.10.6

This is the slackware 12.1 (recent) standard version. What's wrong?

In case it's useful, my /etc/sensors.conf is at:

http://members.home.nl/rene.herman/sensors.conf

Rene.
