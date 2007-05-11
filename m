Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbXEKXIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbXEKXIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXEKXI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:08:27 -0400
Received: from mga05.intel.com ([192.55.52.89]:1868 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600AbXEKXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:08:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,524,1170662400"; 
   d="scan'208";a="244803523"
Message-ID: <4644F726.1050806@linux.intel.com>
Date: Fri, 11 May 2007 16:07:18 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-acpi@vger.kernel.org
Subject: [announce] Intel announces the PowerTOP utility for Linux
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


What's eating the battery life of my laptop? Why isn't it many more 
hours? Which software component causes the most power to be burned? 
These are important questions without a good answer... until now.

The Linux 2.6.21 kernel introduces the so called tickless-idle 
feature. This feature allows the processor to be really idle for long 
periods of time, rather than having to wake up every millisecond for 
the timer tick. Current processors save a lot of power if they are 
idle for long periods, which translates into a longer battery life for 
your laptop, or a lower energy bill for your datacenter. However, a 
Linux system consists of more software than just the kernel, and there 
are many tunables involved. It's not easy to see what is going on, and 
as a result the behavior is sometimes far from optimal, and a lot of 
power is wasted.

Intel is proud to announce the PowerTOP tool 
(http://www.linuxpowertop.org), a program that collects the various 
pieces of information from your system and presents an overview of how 
well your laptop is doing in terms of power savings. In addition, 
PowerTOP will provide an indication of which tunables and software 
components are the biggest offenders in slurping up your battery time. 
PowerTOP will update it's display frequently so that you can directly 
see the impact of any changes you are making.

A typical Linux distribution has many components that wake the 
processor up frequently for no good reason. In our testing with 
PowerTOP, we have seen many cases where with some simple fixes, the 
battery life of typical laptops was increased by one hour or more!

We are providing fixes for several of the issues we identified, and we 
encourage the Linux community to help us in this quest to get the 
maximum battery life out of your (hopefully Intel based) laptops. Try 
the PowerTOP tool, join the mailing list or the IRC channel and 
provide feedback, problem reports or fixes!

Website:      http://www.linuxpowertop.org
IRC:          irc.oftc.net    #powertop channel
Mailing list: http://www.bughost.org/mailman/listinfo/power
