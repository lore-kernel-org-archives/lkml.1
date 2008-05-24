Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbYEXBZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbYEXBZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 21:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYEXBZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 21:25:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbYEXBZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 21:25:33 -0400
Date: Fri, 23 May 2008 18:25:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
Subject: Re: cpufreq limits avilable frequencies to 800MHz on git kernel
Message-Id: <20080523182507.29a2b10c.akpm@linux-foundation.org>
In-Reply-To: <200805231944.57320.arekm@maven.pl>
References: <200805231944.57320.arekm@maven.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 19:44:57 +0200 Arkadiusz Miskiewicz <arekm@maven.pl> wrote:

> thinkpad z60m, Intel(R) Pentium(R) M processor 2.00GHz. kernel from git from 
> 1-2 days ago. 
> 
> Unfortunately it seems that suspend to ram/resume causes frequency
> to be limited to 800MHz only. I can't set it to 2GHz again :-/
> 
> scaling_max_freq is then 800000 and cannot be changed.
> 
> reboot and the problem disappears until new suspend/resume cycle.
> 
> cpufreq stuff is driven by acpi-cpufreq
> 
> $ cpufreq-info
> cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
> Report errors and bugs to linux@brodo.de, please.
> analyzing CPU 0:
>   driver: acpi-cpufreq
>   CPUs which need to switch frequency at the same time: 0
>   hardware limits: 800 MHz - 2.00 GHz
>   available frequency steps: 2.00 GHz, 1.60 GHz, 1.33 GHz, 1.07 GHz, 800 MHz
>   available cpufreq governors: powersave, userspace, ondemand, performance
>   current policy: frequency should be within 800 MHz and 800 MHz.
>                   The governor "performance" may decide which speed to use
>                   within this range.
>   current CPU frequency is 800 MHz.
> 
> /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:800000
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:2000000
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:800000
> /sys/devices/system/cpu/cpu0/cpufreq/related_cpus:0
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:2000000 
> 1600000 1333000 1066000 800000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:powersave 
> userspace ondemand performance
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:800000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:acpi-cpufreq
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:performance
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:800000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:800000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:<unsupported>

Thanks.  Is this a newly-occurring bug or did earlier kernels do this also?

If it was newly added, do you know in which kernel version we might
have added it?

