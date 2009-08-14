Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZHNCiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZHNCiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZHNCiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:38:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:53144 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbZHNCiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:38:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,378,1246863600"; 
   d="scan'208";a="438871917"
Subject: Re: acpi_ex_system_memory_space_handler oops
From: Lin Ming <ming.m.lin@intel.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Len Brown <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090813124647.GA19195@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
	 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
	 <20090813124647.GA19195@localdomain.by>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 10:34:43 +0800
Message-Id: <1250217283.2987.16.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 20:46 +0800, Sergey Senozhatsky wrote:
> > Looks like regression is in the current RC.
> 
> Looks like it isn't. On 17th reboot rc5-git0 crashed.
> (I'll recompile and try more.)
> I think bisecting here is kind of senseless. You never know how much reboots you need.
> Simple delay (like vga=791) - and everything is ok. We need to come up with something 
> more clever, I guess.
> 
> Any thougths?

Hi, Sergey

Could you please help to locate the line of code that causes oops, as
below?

1. Compile the kernel with debug info
   Kernel menuconfig -> Kernel hacking -> Compile the kernel with debug info

2. Retest until it oops, here you get the address of code that causes oops.
   addr2line -e vmlinux <the address>

Thanks,
Lin Ming

> 
> 	Sergey

