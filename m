Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbXIYRcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbXIYRcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbXIYRcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:32:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbXIYRcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:32:08 -0400
Date: Tue, 25 Sep 2007 10:31:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Greg.Chandler@wellsfargo.com,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/1] Kernel compile bug in 2.6.22.6/7 {maybe more}
 ARM/StrongARM
Message-Id: <20070925103142.c93719b3.akpm@linux-foundation.org>
In-Reply-To: <20070925172255.GL8127@redhat.com>
References: <1E7A4807A136DF45AD33DB341D93C3BD1F0C19@msgswbmnmsp46.wellsfargo.com>
	<20070925073132.GA29127@flint.arm.linux.org.uk>
	<20070925143651.GA2769@redhat.com>
	<20070925095229.d1aec1a5.akpm@linux-foundation.org>
	<20070925165834.GE2769@redhat.com>
	<20070925100839.8d2e7b40.akpm@linux-foundation.org>
	<20070925172255.GL8127@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 13:22:55 -0400 Dave Jones <davej@redhat.com> wrote:

>  > 
>  > OK, here: ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/broken-out/fix-x86_64-mm-sched-clock-share.patch
>  > 
>  > So I guess what we want to do here is to revert that patch, test i386
>  > allnoconfig and then fix up anything which breaks.
> 
> Nothing breaks for me with make ARCH=i386 bzImage on my x86-64 box
> (which should be the same as a native build).

Was that with allnoconfig?

> The functions that complain in that patch header don't seem to actually
> exist in mainline at all. (`init_sched_clock' and `call_r_s_f')
> Did this patch perhaps jump the gun, and these are -mm only ?

Could be that this patch fixed version 17 of sched-clock-share and we ended
up merging verion 56.  It was awful.
