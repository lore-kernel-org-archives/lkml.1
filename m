Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZBDCKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZBDCKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZBDCKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:10:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:24820 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZBDCKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:10:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,375,1231142400"; 
   d="scan'208";a="662525836"
Subject: Re: Acer 6592 TM, suspend to ram and resume freeze
From: yakui_zhao <yakui.zhao@intel.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <873aevl0l8.fsf@free.fr>
References: <873aevl0l8.fsf@free.fr>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Wed, 04 Feb 2009 10:21:59 +0800
Message-Id: <1233714119.3684.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 04:36 +0800, Robert Jarzmik wrote:
> First of all, sorry for the duplicate on linux-pm, but as Pavel suggested, this
> topic gains wider audience as acpi and pm are involved.
> 
> I have an issue with my laptop with suspend to ram.
> My laptop is an Acer Travelmate 6592g :
> 
> > [rj@velvet wireshark-1.0.5 (master)]$ sudo s2ram -i
> > This machine can be identified by:
> >     sys_vendor   = "Acer"
> >     sys_product  = "TravelMate 6592"
> >     sys_version  = "PSMBOU-1234567"
> >     bios_version = "V1.53   "
> 
> The kernel running is the last I have : 2.6.29-rc1, but the problem is the same
> whatever the kernel version I take (between 2.6.16 and 2.6.29-rc1).
Will you please try the latest kernel(2.6.29-rc3)?
     If the problem still exists, please attach the output of dmesg,
acpidump.

Thanks.
> 
> The issue is that even if the laptop enters suspend correctly, it hangs on
> comming out of it. After some research, I cornered down the module which changes
> the behaviour : acpi_cpufreq.ko.
> 
> When I forbid the laptop to load this module, the suspend to ram works like a
> charm, in "init" single mode or multi-user mode. When I load the module, the
> resume always hangs (fan goes high speed like crazy, no LCD back, hard drive led
> stays on, caps_lock key not responsive, ...)
> 
> Now, I notice that loading acpi-cpufreq triggers the following message :
> > log: Jan 19 18:23:42 velvet kernel: ACPI: EC: non-query interrupt received, switching to interrupt mode
> 
> As this is not the part of the kernel I'm most at ease with, I'd like some help
> to investigate. I'll gladly make any test or apply patches to my own git tree.
> 
> I join to this mail a URL [1] to see the little information I have :
>  - kernel messages (/var/log/messages), for single user startup
>  - ACPI table
>  - my kernel configuration
>  - kernel message for a working suspend to ram (ie. without acpi_cpufreq).
>  - I suspend using s2ram -f -v -p -s
> 
> Best regards.
> 
> --
> Robert
> 
> [1] http://belgarath.hd.free.fr/download/acer6592tm/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

