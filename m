Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXIIBRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXIIBRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 21:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXIIBRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 21:17:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10503 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbXIIBRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 21:17:44 -0400
Date: Sat, 8 Sep 2007 18:16:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "James C. Georgas" <jgeorgas@georgas.ca>
Subject: Re: broken ACPI NUMA config option
Message-Id: <20070908181607.4f36479c.randy.dunlap@oracle.com>
In-Reply-To: <20070908180904.656f3d03.randy.dunlap@oracle.com>
References: <1189291899.13467.20.camel@Tachyon.home>
	<20070908180904.656f3d03.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2007 18:09:04 -0700 Randy Dunlap wrote:

> On Sat, 08 Sep 2007 18:51:39 -0400 James C. Georgas wrote:
> 
> > If I select X86_64_ACPI_NUMA, then ACPI_NUMA is (properly) selected
> > automatically, but ACPI is not selected automatically. This causes
> > ACPI_NUMA to not be built, and the kernel compile fails with unresolved
> > symbols.
> 
> exactly what kernel version??
> 

2.6.23-rc5-git1 builds for me when I follow those steps...
except for some Section mismatch warnings.


> > Steps to reproduce:
> > 
> > 	make clean
> > 	make mrproper
> > 	make noallconfig
> > 
> > 	select SMP
> > 	select NUMA
> > 	select X86_64_ACPI_NUMA
> > 
> > 	make
> > 	<boom>
> > 
> > results:
> > 
> > 	  LD      .tmp_vmlinux1
> > 	drivers/built-in.o: In function `acpi_bus_generate_event':
> > 	(.text+0x23365): undefined reference to `event_is_open'
> > 	drivers/built-in.o: In function `acpi_bus_get_power':
> > 	(.text+0x2361d): undefined reference to `acpi_power_get_inferred_state'
> > 	drivers/built-in.o: In function `acpi_bus_set_power':
> > 	(.text+0x23733): undefined reference to `acpi_power_transition'
> > 	drivers/built-in.o: In function `acpi_bus_set_power':
> > 	(.text+0x237a5): undefined reference to `acpi_power_transition'
> > 	make: *** [.tmp_vmlinux1] Error 1
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
