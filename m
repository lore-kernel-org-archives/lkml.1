Return-Path: <linux-kernel-owner+w=401wt.eu-S1422934AbXBAUim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422934AbXBAUim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422988AbXBAUim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:38:42 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:22356 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422934AbXBAUil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:38:41 -0500
Message-ID: <45C24FCE.7000503@fr.ibm.com>
Date: Thu, 01 Feb 2007 21:38:38 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: "Starikovskiy, Alexey Y" <alexey.y.starikovskiy@intel.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Moore, Robert" <robert.moore@intel.com>,
       keith mannthey <kmannth@us.ibm.com>
Subject: Re: 2.6.20-rc6-mm3
References: <B41635854730A14CA71C92B36EC22AAC7CC65D@mssmsx411> <45C24DC1.3050801@fr.ibm.com>
In-Reply-To: <45C24DC1.3050801@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> Starikovskiy, Alexey Y wrote:
>> Sorry, here is the patch... ACPI has switched to acpi_find_rsdp(), so
>> srat.c might want to do that too, please check.
> 
> got it. running a compile and boot test. 

hmm, i got another issue while compiling :

  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/i386/kernel/built-in.o: In function `get_memcfg_from_srat':
/home/legoater/linux/2.6.20-rc6-mm3/arch/i386/kernel/srat.c:279: undefined reference to `acpi_find_root_pointer'

it seems that drivers/acpi/tables/tbxfroot.c is never compiled ? 
 
> I should have the results in 'my' morning (UTC+1).

I'll catchup in the morning.

thanks,

C.
