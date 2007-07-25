Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbXGYMZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbXGYMZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXGYMZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:25:06 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41872 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXGYMZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:25:03 -0400
Message-ID: <46A7411C.80202@fr.ibm.com>
Date: Wed, 25 Jul 2007 14:25:00 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/

I'm having issue compiling on i386 and x86_64. 

make defconfig on i386  :

  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o(.text+0x9649): In function `acpi_pci_choose_state':
: undefined reference to `acpi_pm_device_sleep_state'
drivers/built-in.o(.text+0x3b2f5): In function `pnpacpi_suspend':
: undefined reference to `acpi_pm_device_sleep_state'

probably this commit fd4aff1a28eecbd729b409bf7d3eff5948f20414 in the acpi tree.

Thanks,

C.
