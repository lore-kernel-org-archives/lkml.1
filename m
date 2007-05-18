Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbXERQB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbXERQB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbXERQBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:01:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbXERQBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:01:20 -0400
Date: Fri, 18 May 2007 12:01:08 -0400
From: Dave Jones <davej@redhat.com>
To: Ed Sweetman <safemode2@comcast.net>
Cc: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>, Duane Griffin <duaneg@dghda.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Message-ID: <20070518160108.GA28021@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ed Sweetman <safemode2@comcast.net>,
	Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>,
	Duane Griffin <duaneg@dghda.com>,
	Prakash Punnoor <prakash@punnoor.de>,
	LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@gentoo.org>
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com> <20070516204807.GA23751@redhat.com> <20070518030436.GB20793@ifa.hawaii.edu> <464D2702.1060001@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464D2702.1060001@comcast.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 12:09:38AM -0400, Ed Sweetman wrote:
 > the previous post i keep referring you to has a patch that was mangled 
 > ...here is the non-mangled version
 > 
 > --- ./linux-backup/arch/x86_64/kernel/cpufreq/Kconfig   2007-02-04 
 > 13:44:54.000000000 -0500
 > +++ ./linux-2.6.21-rc5-mm2/arch/x86_64/kernel/cpufreq/Kconfig 
 > 2007-05-17 18:13:07.000000000 -0400
 > @@ -10,20 +10,27 @@
 > 
 >   comment "CPUFreq processor drivers"
 > 
 > -config X86_POWERNOW_K8
 > +config  X86_POWERNOW_K8
 >          tristate "AMD Opteron/Athlon64 PowerNow!"

still has unnecessary whitespace changes

 >          select CPU_FREQ_TABLE
 >          help
 >            This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 
 > processors.
 > +         An acpi interface is available if acpi support has been selected.
 > +         This is required for multi-socket and other systems but not 
 > necessarily required for UP single socket systems.

and still wordwrapped.
(also capitalise ACPI)

	Dave

-- 
http://www.codemonkey.org.uk
