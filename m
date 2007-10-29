Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXJ2HC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXJ2HC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXJ2HCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:02:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbXJ2HCt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:02:49 -0400
Date: Mon, 29 Oct 2007 00:02:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Toralf =?ISO-8859-1?B?RvZyc3Rlcg==?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, cpufreq@www.linux.org.uk
Subject: Re: cpu governor ondemand issue
Message-Id: <20071029000243.9101d363.akpm@linux-foundation.org>
In-Reply-To: <200710211316.14955.toralf.foerster@gmx.de>
References: <200710211316.14955.toralf.foerster@gmx.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 13:16:14 +0200 Toralf Förster <toralf.foerster@gmx.de> wrote:

> I use the following one liner for regression tests of the cpufreq governor and
> friends:
> 
> tfoerste@n22 ~ $ time factor 819734028463158891
> 
> which usually needs 5.5 secs to complete at 1.7 GHz of my pentium M processor.
> 
> With the  current git sources (commit cfa76f0 at Sat Oct 20 20:19:15 2007 -0700)
> instead this command needs 3 times longer if I run the "distributed.net client"
> as a background process with nice level 19 b/c the cpu frequency still stays
> at 600 MHz.
> After stopping dnetc the cpu frequency governor ondemand works as expected again.
> 
> Tested at my ThinkPad T41 with stable Gentoo:
> 
> tfoerste@n22 ~ $ grep -e ^CONFIG_ACPI -e ^CONFIG_CPU_FREQ_GOV_ ~/devel/linux-2.6/.config
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> CONFIG_ACPI_PROCFS=y
> CONFIG_ACPI_PROC_EVENT=y
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=m
> CONFIG_ACPI_PROCESSOR=m
> CONFIG_ACPI_THERMAL=m
> CONFIG_ACPI_BLACKLIST_YEAR=0
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> 

And 2.6.23 was OK?

Is this problem still present in Linus's current tree?

Thanks.
