Return-Path: <linux-kernel-owner+w=401wt.eu-S1751004AbZHMATM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004AbZHMATM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 20:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbZHMATL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 20:19:11 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:41958 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZHMATL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 20:19:11 -0400
Date: Wed, 12 Aug 2009 20:18:37 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: acpi_ex_system_memory_space_handler oops
In-reply-to: <20090812201034.GA2983@localdomain.by>
Message-id: <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
References: <20090812201034.GA2983@localdomain.by>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Kernel oopses on early boot stages (boots normally with boot_delay=10).

> rc5-git8

Please find which kernel this failure starts in.
Start by testing 2.6.30.stable so we can tell
if this is a regression in the current RC.

What is the difference between the two dmesg?
they have the same cmdline, neither has boot_delay,
and neither dmesg shows the oops.

The fact that boot_delay=10 makes the problem go away
suggests some sort of race condition.  Is 10 the smallest
value of printk_time that works, or is it a random value?

Do you still see the oops with CONFIG_PRINTK_TIME=n?

Do you still see the oops with maxcpus=1?

Do you still see the oops with "acpi_serialize=1"?

Please open a bug report here:
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

answer the questions above and attach the output from acpidump

thanks,
-Len Brown, Intel Open Source Technology Center.
