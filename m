Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbXGACE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbXGACE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 22:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXGACEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 22:04:49 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:43048 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbXGACEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 22:04:48 -0400
Message-ID: <46870BB7.9020901@mandic.com.br>
Date: Sat, 30 Jun 2007 23:04:39 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jeremy@goop.org
Subject: Re: speedstep-centrino (no such device)
References: <fa.jQgBX5GocqZWw6ordgUe/I1tfb0@ifi.uio.no> <468442D4.2030900@shaw.ca>
In-Reply-To: <468442D4.2030900@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Renato S. Yamane wrote:
>> Is impossible use speedstep in my Laptop with Pentium M 1,86Ghz:
>>
>> #modprobe speedstep-centrino
>> FATAL: Error inserting speedstep_centrino 
>> (/lib/modules/2.6.18-3-686/kernel/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.ko): 
>> No such device
>>
>> To do that (speedstep), I need install powersaved, but 
>> speedstep-centrino is not used.
> 
> I believe acpi-cpufreq is preferred over speedstep-centrino in most 
> cases today, does that work?

Robert, acpi_cpufreq works fine to me.
I insert parameter CPUFREQD_MODULE="acpi_cpufreq" in my 
/etc/powersave/cpufreq and now is possible use scaling frequency.

I read 
/usr/src/linux-2.6.21.5/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c 
and see that this module is made using document 25261202.pdf (from 
Intel) as reference.

This document include only some Pentium M models.

My Pentium M is model 750 (1.86GHz) and you can see datasheet on 
document 30526202.pdf available here:
<http://download.intel.com/design/mobile/datashts/30526202.pdf>

What I can choose on "CPUFreq Processor drivers" availiable in .config?
Currently I do that (in Kernel 2.6.21.1):

# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

Best regards,
Renato S. Yamane
