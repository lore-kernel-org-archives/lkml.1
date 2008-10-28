Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYJ1XB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYJ1XB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYJ1XBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:01:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbYJ1XBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:01:49 -0400
Date: Tue, 28 Oct 2008 16:00:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for October 28
Message-Id: <20081028160045.2a890509.akpm@linux-foundation.org>
In-Reply-To: <20081028183055.fbcf5420.sfr@canb.auug.org.au>
References: <20081028183055.fbcf5420.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 18:30:55 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

x86_64 allnoconfig:

arch/x86/kernel/genx2apic_uv_x.c: In function 'uv_rtc_init':
arch/x86/kernel/genx2apic_uv_x.c:355: error: implicit declaration of function 'uv_bios_freq_base'
arch/x86/kernel/genx2apic_uv_x.c: In function 'uv_system_init':
arch/x86/kernel/genx2apic_uv_x.c:438: error: implicit declaration of function 'uv_bios_init'
arch/x86/kernel/genx2apic_uv_x.c:439: error: implicit declaration of function 'uv_bios_get_sn_info'
arch/x86/kernel/genx2apic_uv_x.c:439: error: 'uv_type' undeclared (first use in this function)
arch/x86/kernel/genx2apic_uv_x.c:439: error: (Each undeclared identifier is reported only once
arch/x86/kernel/genx2apic_uv_x.c:439: error: for each function it appears in.)
arch/x86/kernel/genx2apic_uv_x.c:439: error: 'sn_partition_id' undeclared (first use in this function)
arch/x86/kernel/genx2apic_uv_x.c:440: error: 'uv_coherency_id' undeclared (first use in this function)
arch/x86/kernel/genx2apic_uv_x.c:440: error: 'uv_region_size' undeclared (first use in this function)
make[1]: *** [arch/x86/kernel/genx2apic_uv_x.o] Error 1
make: *** [arch/x86/kernel/genx2apic_uv_x.o] Error 2


Guys, allnoconfig breakage is very common.  It's easy to configure and
is very quick to test.  Please use it.
