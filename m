Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXGCAiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXGCAiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbXGCAiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:38:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930AbXGCAiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:38:04 -0400
Date: Mon, 2 Jul 2007 20:36:48 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [2.6 patch] the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI
Message-ID: <20070703003648.GA31035@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	lenb@kernel.org, linux-acpi@vger.kernel.org
References: <20070701202037.GC10869@stusta.de> <20070702232255.GH6403@redhat.com> <20070702234313.GB3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702234313.GB3492@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 01:43:13AM +0200, Adrian Bunk wrote:
 > > Applying '[CPUFREQ] the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI'
 > > 
 > > error: patch failed: arch/x86_64/kernel/cpufreq/Kconfig:65
 > > error: arch/x86_64/kernel/cpufreq/Kconfig: patch does not apply
 > 
 > I made the patch against 2.6.22-rc6-mm1 (based on an older version of 
 > this patch)  but I missed the fuzz (and GNU patch defaults to accept
 > patches with a fuzz of 2).
 > 
 > Below is a version of the patch with the fuzz edited out.

It also has the context edited out :)

 > @@ -65,1 +60,1 @@
 > -	depends on X86_ACPI_CPUFREQ || X86_SPEEDSTEP_CENTRINO_ACPI || X86_POWERNOW_K8_ACPI
 > +	depends on X86_ACPI_CPUFREQ || X86_POWERNOW_K8_ACPI
 > --- linux-2.6.20-mm1/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c.old	2007-02-17 23:29:53.000000000 +0100
 > +++ linux-2.6.20-mm1/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c	2007-02-17 23:30:44.000000000 +0100

This won't apply either.

	Dave

-- 
http://www.codemonkey.org.uk
