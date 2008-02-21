Return-Path: <linux-kernel-owner+w=401wt.eu-S1765734AbYBUHJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765734AbYBUHJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYBUHJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:09:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:42323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbYBUHJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:09:10 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUILD_FAILURE] 2.6.25-rc2-mm1 - Build Failure at acpi_os
Date: Thu, 21 Feb 2008 02:08:47 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B73DD8.4030405@linux.vnet.ibm.com>
In-Reply-To: <47B73DD8.4030405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802210208.47487.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2008 14:47, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The 2.6.25-rc2-mm1 kernel with randconfig build option, fails
> to build on x86_64 machine
> 
>   CC      drivers/acpi/osl.o
> drivers/acpi/osl.c:60:38: error: empty filename in #include
> drivers/acpi/osl.c: In function ‘acpi_os_table_override’:
> drivers/acpi/osl.c:399: error: ‘AmlCode’ undeclared (first use in this function)
> drivers/acpi/osl.c:399: error: (Each undeclared identifier is reported only once
> drivers/acpi/osl.c:399: error: for each function it appears in.)
> make[2]: *** [drivers/acpi/osl.o] Error 1
> make[1]: *** [drivers/acpi] Error 2
> make: *** [drivers] Error 2
> 
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.25-rc2-mm1
> # Sun Feb 17 08:07:17 2008
> #

> CONFIG_ACPI_CUSTOM_DSDT=y
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""

garbage in, garbage out.

If you don't give this build option a file name where AmlCode lives,
then the build will be unable to find AmlCode[].

http://www.lesswatts.org/projects/acpi/overridingDSDT.php

cheers,
-Len
