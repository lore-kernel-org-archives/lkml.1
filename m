Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbZJCUsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbZJCUsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 16:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757134AbZJCUsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 16:48:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39838 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064AbZJCUsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 16:48:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [git pull request] ACPI Processor Aggregator Driver for 2.6.32-rc1
Date: Sat, 3 Oct 2009 22:49:19 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Shaohua Li <shaohua.li@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
References: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910032249.19292.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 October 2009, Len Brown wrote:
> Hi Linus,
> 
> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git acpi-pad
> 
> This will add the ACPI Processor Aggregator Driver to the kernel.
> acpi_pad implements a new ACPI feature where the baseboard management
> controller can ask Linux to force busy processors to stay idle.
> 
> The BMC does this under dire electrical or thermal conditions
> after it has already lowered the P-state to low frequencey mode
> on all processors, yet the emergency persists.  This offline
> technique is used before employing even more invasive measures,
> such as taking T-states down to 1/8th of LFM, or powering-off
> the server completely.
> 
> This driver will have no effect on the installed base,
> no no old systems implement this new feature.  However, this
> simle driver in Linux will be useful as this feature
> is deployed by OEMs on new hardware.
> 
> As I mentioned previously, this is an ACPI patch, not a scheduler patch.
> PeterZ is hoping to implement a more sophisticated method for forcing
> idle time in the system with the scheduler, and when that is available,
> I'll be delighted to update this driver to invoke it.
> 
> thanks!
> 
> --
> Len Brown
> Intel Open Source Technology Center
> 
> 
> ps. individual patches are available on linux-acpi@vger.kernel.org
> and a consolidated plain patch is available here:
> http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.31/acpi-acpi-pad-20090521-2.6.31-rc4.diff.gz
> 
>  MAINTAINERS             |    8 +
>  drivers/acpi/Kconfig    |   12 +
>  drivers/acpi/Makefile   |    2 +
>  drivers/acpi/acpi_pad.c |  514 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 536 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/acpi/acpi_pad.c
> 
> through these commits:
> 
> Len Brown (1):
>       acpi_pad: build only on X86
> 
> Shaohua Li (1):
>       ACPI: create Processor Aggregator Device driver
> 
> with this log:
> 
> commit d91f79ebc3191b15dbe385925af4840f4e68df77
> Author: Len Brown <len.brown@intel.com>
> Date:   Sun Sep 27 02:35:55 2009 -0400
> 
>     acpi_pad: build only on X86
>     
>     X86_FEATURE_MWAIT doesn't exist on ia64...
>     
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> commit 8e0af5141ab950b78b3ebbfaded5439dcf8b3a8d
> Author: Shaohua Li <shaohua.li@intel.com>
> Date:   Mon Jul 27 18:11:02 2009 -0400
> 
>     ACPI: create Processor Aggregator Device driver

Can you please point me to the mailing list thread there this driver was
posted (and possibly reviewed and discussed)?

Best,
Rafael
