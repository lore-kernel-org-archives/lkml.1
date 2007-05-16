Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbXEPQZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbXEPQZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758894AbXEPQZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:25:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524AbXEPQZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:25:24 -0400
Date: Wed, 16 May 2007 12:24:59 -0400
From: Dave Jones <davej@redhat.com>
To: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Message-ID: <20070516162459.GD30166@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>,
	LKML <linux-kernel@vger.kernel.org>
References: <20070516011711.GE15763@ifa.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516011711.GE15763@ifa.hawaii.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<dropping trivial@ from cc: as this definitly isn't>

On Tue, May 15, 2007 at 03:17:11PM -1000, Joshua Hoblitt wrote:
 
 > --- linux-2.6.21.1.orig/arch/i386/kernel/cpu/cpufreq/Kconfig    2007-04-27 11:49:26.000000000 -1000
 > +++ linux-2.6.21.1/arch/i386/kernel/cpu/cpufreq/Kconfig 2007-05-15 14:48:50.000000000 -1000
 > @@ -82,6 +82,7 @@ config X86_POWERNOW_K8
 >         tristate "AMD Opteron/Athlon64 PowerNow!"
 >         select CPU_FREQ_TABLE
 >         depends on EXPERIMENTAL
 > +       depends on X86_ACPI_CPUFREQ
 >         help
 >           This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.

This is completely the wrong thing to do.
There's no dependancy between these two modules, as they are two independant
cpufreq drivers.  I think you may be confused with X86_POWERNOW_K8_ACPI
(Which should get set if you have ACPI_PROCESSOR enabled)

	Dave

-- 
http://www.codemonkey.org.uk
