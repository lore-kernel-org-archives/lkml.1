Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbYFVHX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbYFVHX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 03:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYFVHXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 03:23:20 -0400
Received: from smtp1.versatel.nl ([62.58.50.88]:40465 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYFVHXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 03:23:19 -0400
Message-ID: <485DFF35.6080008@hhs.nl>
Date: Sun, 22 Jun 2008 09:28:53 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] LMSENSORS: 2.6.26-rc,	enabling ACPI Termal Zone
 support costs sensors
References: <485DA11C.7050906@keyaccess.nl>
In-Reply-To: <485DA11C.7050906@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Good day.
> 
> On 2.6.26-rc and perhaps earlier, when I enable the ACPI Thermal Zone 
> support (CONFIG_ACPI_THERMAL) I see in dmesg:
> 
> ACPI: LNXTHERM:01 is registered as thermal_zone0
> ACPI: Thermal Zone [THRM] (56 C)
> 
> My /sys/class/hwmon/hwmon0 (a W83782D chip) becomes hwmon1, there's a 
> new /sys/class/hwmon/hwmon0 and "sensors -s" craps out with:
> 
> # sensors -s
> Can't access procfs/sysfs file
> Kernel interface access error
> For 2.6 kernels, make sure you have mounted sysfs and libsensors
> was compiled with sysfs support!
> 
> # sensors --version
> sensors version 2.10.6 with libsensors version 2.10.6
> 
> This is the slackware 12.1 (recent) standard version. What's wrong?
> 
> In case it's useful, my /etc/sensors.conf is at:
> 
> http://members.home.nl/rene.herman/sensors.conf
> 

I'm pretty sure this caused by your lm_sensors using space being to old to 
support the new thermalzone stuff. You need atleast 3.0.2 to support the 
thermalzone driver.

Regards,

Hans
