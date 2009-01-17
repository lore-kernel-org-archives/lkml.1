Return-Path: <linux-kernel-owner+w=401wt.eu-S1763844AbZAQPuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763844AbZAQPuu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762032AbZAQPuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:50:25 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:38827 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762070AbZAQPuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:50:23 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.29-rc1: [SOLVED] thinkpad problems during resume
Date: Sat, 17 Jan 2009 16:48:34 +0100
User-Agent: KMail/1.9.9
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>
References: <20090113081316.GA2292@elf.ucw.cz> <20090116104455.GA3283@elf.ucw.cz> <200901171546.15987.borntraeger@de.ibm.com>
In-Reply-To: <200901171546.15987.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901171648.34155.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> commit e39ad415ac15116df213dfa2aa2a4f1b0857af9c
> Author: Mike Travis <travis@sgi.com>
> Date:   Sun Jan 4 05:18:10 2009 -0800
>
>     cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
>
> makes cpu hotplug working again. Resume from suspend to ram is still broken
> on my Thinkpad. Looks like there is yet another patch to find....
>
> Ingo, Mike: reverting e39ad415ac15116df213dfa2aa2a4f1b0857af9c fixes cpu
> hotplug on my thinkpad. Any idea how to proceed? Should we revert that
> patch in Linus git until we know what was wrong?

I forgot to revert the usb patch.
Current status:
2.6.29-rc2 + 
reverted e39ad415ac15116df213dfa2aa2a4f1b0857af9c (cpumask: use work_on_cpu in 
acpi-cpufreq.c for read_measured_perf_ctrs) + 
reverted a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 (USB: fix up suspend and 
resume for PCI host controllers)

has a working suspend to ram on my T61p. With any of these two patches not 
reverted resume hangs.

Christian
