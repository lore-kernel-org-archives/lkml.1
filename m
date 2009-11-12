Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZKLRlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZKLRlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZKLRlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:41:09 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:59200 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbZKLRlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:41:07 -0500
Date: Thu, 12 Nov 2009 09:40:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for November 12 (acpi/processor.h)
Message-Id: <20091112094012.2ef401ad.randy.dunlap@oracle.com>
In-Reply-To: <20091112195101.63263490.sfr@canb.auug.org.au>
References: <20091112195101.63263490.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AFC4895.003C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 19:51:01 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20091111:
> 
> The cpufreq tree gained a conflict against the acpi tree.

when CONFIG_CPU_FREQ=n:

arch/x86/kernel/acpi/processor.o: In function `acpi_processor_get_bios_limit':
(.text+0x0): multiple definition of `acpi_processor_get_bios_limit'
arch/x86/kernel/acpi/cstate.o:(.text+0x0): first defined here


The function definition in include/apci/procssor.h needs to be "static inline"
at line 323.

---
~Randy
