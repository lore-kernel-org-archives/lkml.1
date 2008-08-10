Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYHJDVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYHJDVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 23:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYHJDUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 23:20:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:3790 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbYHJDUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 23:20:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,336,1215414000"; 
   d="scan'208";a="605439794"
Subject: Re: Regression in 2.6.27-rc2 in acpi_processor_init()
From: Zhao Yakui <yakui.zhao@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200808082302.11358.rjw@sisk.pl>
References: <6453C3CB8E2B3646B0D020C112613273C5AC59@sausexmb4.amd.com>
	 <200808082302.11358.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 10 Aug 2008 11:34:36 +0800
Message-Id: <1218339276.6671.43.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 23:02 +0200, Rafael J. Wysocki wrote:
> [Adding CCs]
> 
Hi, Mark
   Will you please attach the output of acpidump on bug 11287?
   Of course it will be great if you can enable CONFIG_ACPI_DEBUG and
CONFIG_CPUFREQ_DEBUG in kernel configuration  and boot the system with
the option of "cpufreq.debug=7 acpi.debug_layer=0x01010000
acpi.debug_level=0x17".
   After the system is booted, please attach the output of dmesg.
   Please do the above test on both kernel 2.6.27-rc1 and 2.6.27-rc2.

Thanks.
> On Friday, 8 of August 2008, Langsdorf, Mark wrote:
> > I got a regression when updated from 2.6.27-rc1 ro
> > 2.6.27-rc2.  The noticeable symptom is the powernow-k8
> > driver stopped working because the call to 
> > acpi_processor_register_performance() is returning
> > -EINVAL.
> >
> > Digging into the code a bit more, that's occurring
> > because acpi_processor_ppc_status is not set.
> > That should be set in acpi_processor_init(), but
> > that function is failing to register the ACPI
> > processor driver.
> > 
> > I've dug through the code and can't see why 
> > that call would fail.  It doesn't look like there
> > were any changes between 2.6.27-rc1 and 2.6.27-rc2,
> > but I may have missed something.
> > 
> > Any advice or suggestions in debugging this 
> > appreciated.
> > 
> > -Mark Langsdorf
> > Operating System Research Center
> > AMD
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

