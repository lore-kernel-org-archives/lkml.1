Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXEQSZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXEQSZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbXEQSZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:25:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275AbXEQSY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:24:59 -0400
Date: Thu, 17 May 2007 14:23:40 -0400
From: Dave Jones <davej@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: Daniel Drake <dsd@gentoo.org>, duaneg@dghda.com, prakash@punnoor.de,
       jhoblitt@ifa.hawaii.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Message-ID: <20070517182340.GA25691@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Len Brown <lenb@kernel.org>, Daniel Drake <dsd@gentoo.org>,
	duaneg@dghda.com, prakash@punnoor.de, jhoblitt@ifa.hawaii.edu,
	linux-kernel@vger.kernel.org
References: <20070516235050.9B4237B409F@zog.reactivated.net> <200705171413.42595.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705171413.42595.lenb@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 02:13:42PM -0400, Len Brown wrote:

 > > Index: linux/arch/i386/kernel/cpu/cpufreq/Kconfig
 > > ===================================================================
 > > --- linux.orig/arch/i386/kernel/cpu/cpufreq/Kconfig
 > > +++ linux/arch/i386/kernel/cpu/cpufreq/Kconfig
 > > @@ -81,6 +81,7 @@ config X86_POWERNOW_K7_ACPI
 > >  config X86_POWERNOW_K8
 > >  	tristate "AMD Opteron/Athlon64 PowerNow!"
 > >  	select CPU_FREQ_TABLE
 > > +	select ACPI_PROCESSOR if SMP
 > >  	depends on EXPERIMENTAL
 > >  	help
 > >  	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.
 > 
 > Unfortunately this patch will not actually enable ACPI_PROCESSOR in
 > the SMP=y ACPI=n case.  "select" doesn't work for targets that
 > have dependencies.

I don't think we can fix this perfectly tbh, but the above at
least gets us close for the majority of users.

Are there many x86-64 users that don't enable acpi ?

	Dave

-- 
http://www.codemonkey.org.uk
