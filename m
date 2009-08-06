Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZHFViE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZHFViE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZHFViD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:38:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53556 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777AbZHFViC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:38:02 -0400
Date: Thu, 6 Aug 2009 17:38:00 -0400
From: Dave Jones <davej@redhat.com>
To: linuxcbon <linuxcbon@yahoo.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: modprobe acpi-cpufreq FATAL: Error inserting
Message-ID: <20090806213800.GA7760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	linuxcbon <linuxcbon@yahoo.fr>, linux-kernel@vger.kernel.org
References: <281886.98991.qm@web26108.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <281886.98991.qm@web26108.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 08:10:45PM +0000, linuxcbon wrote:
 > Hi,
 > 
 > I have an AMD Athlon 64 X2.
 > I did :
 > # modprobe acpi-cpufreq
 > FATAL: Error inserting acpi_cpufreq (/lib/modules/2.6.30.1/kernel/arch/x86/=
 > kernel/cpu/cpufreq/acpi-cpufreq.ko): Device or resource busy
 > 
 > I thought that module was general...I know there are other modules for each kind of processors, but can you make one module for all processors or do we need to use the specific ones ?

powernow-k8 is the preferred driver for your processor.
By the looks of things, that got loaded first, so has claimed the interface already.
acpi-cpufreq will drive your hardware too if nothing else has been loaded first,
and as long as your BIOS has the relevant ACPI tables.

	Dave

