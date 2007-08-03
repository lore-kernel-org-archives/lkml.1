Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbXHCLn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbXHCLn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 07:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760765AbXHCLnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 07:43:50 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:59140 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760753AbXHCLns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 07:43:48 -0400
Message-ID: <46B314F0.1070503@mandic.com.br>
Date: Fri, 03 Aug 2007 08:43:44 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, trenn@suse.de, pavel@ucw.cz,
       mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
References: <46B1988C.3090302@t-online.de> <200708021756.30776.lenb@kernel.org>
In-Reply-To: <200708021756.30776.lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown escreveu:
> On Thursday 02 August 2007 04:40, Knut Petersen wrote:
>> mainboard: AOpen i915GMm-hfs, AWARD BIOS
>> cpu: Pentium-M 750 (0.8 to 1.86 MHz)
>> openSuSE 10.2 with kernel 2.6.22.1
>>
>> The cpu fan can not be controled by linux kernel.
>> The BIOS will switch on the cpu fan a bit above 50 deg. Celsius.
>> The active and passive trip points both are set to 50 deg. Celsius.
>> Temperature of the idle cpu at 800 Mhz: 34 to 42 deg. C.
>> The BIOS never changes the trip points.
>> Cpufreq does work perfectly.

On my Toshiba M45-S355 (Toshiba Bios, Pentium M 750 - 0.8 at 1.86GHz, 
Debian Etch) I see the same using Kernel 2.6.21.6

>> Previously there was the possibility  to add something like
>>
>> echo  "100:0:65:70:0" > /proc/acpi/thermal_zone/THRM/trip_points
>> echo  2 > /proc/acpi/thermal_zone/THRM/polling_frequency
>> echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

I never do that, but see below (Kernel 2.6.21.6):

cat /proc/acpi/thermal_zone/TZCL/trip_points
critical (S5):           105 C

cat /proc/acpi/thermal_zone/TZCL/polling_frequency
polling frequency:       2 seconds

cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
ondemand

Regards,
Renato S. Yamane
