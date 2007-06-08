Return-Path: <linux-kernel-owner+w=401wt.eu-S971145AbXFHWa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971145AbXFHWa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971135AbXFHW3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:29:05 -0400
Received: from ns1.suse.de ([195.135.220.2]:36669 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S971236AbXFHW3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:29:01 -0400
From: Andi Kleen <ak@suse.de>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Subject: Re: [PATCH 0/2] i386: Fix two more NMI watchdog bugs
Date: Sat, 9 Jun 2007 00:28:18 +0200
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <465C2225.2000100@googlemail.com> <20070608204324.GA25392@elte.hu> <20070608224911.3ff6bd18@laptop.hypervisor.org>
In-Reply-To: <20070608224911.3ff6bd18@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706090028.19703.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> None of the patches posted by Björn fix the kernel BUG at
> arch/i386/kernel/cpu/perfctr-watchdog.c:126! that occurs when doing
> echo 0 > /proc/sys/kernel/nmi_watchdog
>
> Call Trace:
>  [<c010c429>] single_msr_unreserve+0xd/0x1a
>  [<c010c668>] disable_lapic_nmi_watchdog+0x27/0x35
>  [<c0110ac6>] proc_nmi_enabled+0xa0/0xbd
>  [<c018550c>] proc_sys_write+0x6f/0x8c
>  [<c018549d>] proc_sys_write+0x0/0x8c
>  [<c0156e5b>] vfs_write+0x8a/0x10c
>  [<c0157317>] sys_write+0x41/0x67
>  [<c0103c30>] syscall_call+0x7/0xb
>
> Andi, did you have a patch for that?

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/disable-watchdog

-Andi
