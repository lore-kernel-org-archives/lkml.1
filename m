Return-Path: <linux-kernel-owner+w=401wt.eu-S1763576AbXHFKSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763576AbXHFKSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbXHFKSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:18:05 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:36792 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762414AbXHFKSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:18:04 -0400
Date: Mon, 6 Aug 2007 13:18:03 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
In-Reply-To: <200708051912.17342.rjw@sisk.pl>
Message-ID: <Pine.SOC.4.64.0708061314380.7974@math.ut.ee>
References: <Pine.SOC.4.64.0708041425020.26419@math.ut.ee> <200708050010.19338.rjw@sisk.pl>
 <Pine.SOC.4.64.0708051217340.11960@math.ut.ee> <200708051912.17342.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, with this .config SUSPEND_SMP cannot be set, because SMP is unset in it.
> 
> Can you please check if this warning is still present with the patch from
> http://marc.info/?l=linux-kernel&m=118633307113052&w=2 applied?

Hmm, does not apply to 2.6.23-rc2:
2 out of 2 hunks FAILED -- saving rejects to file kernel/power/Kconfig.rej
1 out of 1 hunk FAILED -- saving rejects to file arch/x86_64/Kconfig.rej
1 out of 1 hunk FAILED -- saving rejects to file arch/arm/Kconfig.rej
1 out of 1 hunk FAILED -- saving rejects to file arch/i386/Kconfig.rej
1 out of 1 hunk FAILED -- saving rejects to file arch/powerpc/Kconfig.rej

It doesn't seem to touch arch/ppc/Kconfig but only arch/powerpc/Kconfig 
- should it make any difference at all?

-- 
Meelis Roos (mroos@linux.ee)
