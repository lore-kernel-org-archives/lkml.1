Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZDTDWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZDTDWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 23:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZDTDWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 23:22:44 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:47643 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZDTDWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 23:22:43 -0400
Date: Sun, 19 Apr 2009 23:22:36 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, efault@gmx.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       yakui.zhao@intel.com, yanmin_zhang@linux.intel.com
Subject: Re: [patch for 2.6.30 2/2] arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c:
 avoid cross-CPU interrupts
In-reply-to: <200904151605.05989.rusty@rustcorp.com.au>
Message-id: <alpine.LFD.2.00.0904192320450.10996@localhost.localdomain>
References: <200904110617.n3B6HJ7W026502@imap1.linux-foundation.org>
 <200904141821.37413.rusty@rustcorp.com.au>
 <20090414101817.0c935261.akpm@linux-foundation.org>
 <200904151605.05989.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Andrew points out that acpi-cpufreq uses cpumask_any, when it really
> would prefer to use the same CPU if possible (to avoid an IPI).  In
> general, this seems a good idea to offer.

I like this idea.

I'll drop andrew's patch "acpi-cpufreq.c: avoid cross-CPU interrupts"
b/c that is not an emergency and this is more clever.

thanks,
-Len Brown, Intel Open Source Technology Center.
