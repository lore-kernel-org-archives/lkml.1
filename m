Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZF3KI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZF3KI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZF3KIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:08:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZF3KIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:08:50 -0400
Date: Tue, 30 Jun 2009 03:07:57 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, jeremy.fitzhardinge@citrix.com
Subject: Re: WARNING: at mm/bootmem.c:535 alloc_arch_preferred_bootmem
In-Reply-To: <1246351243.8014.14.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.01.0906300300000.6439@bogon>
References: <alpine.DEB.2.01.0906291950280.6439@bogon> <1246351243.8014.14.camel@penberg-laptop>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19ftxDiO0Q2FQk2CdQMjhqJR6MImskYE7sJYWT
 NLVXaEZMZ4SwrfRlnXe+0mhcDWNceHD0SUmU5kn68q4xpKu3yw
 nmw+guZBd7ffJvKdabTqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Pekka Enberg wrote:
> I think you're the first one to report this. The warning is harmless but
> the following patch should fix things up. Thanks!

Yes, your patch makes the warning go away, Thanks!

But, I think the patch description should read:

> Fixes the following boot-time warning:
> ------------[ cut here ]------------
> WARNING: at mm/bootmem.c:535 alloc_arch_preferred_bootmem+0x27/0x45()
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.30 #1
> Call Trace:
>  [<ffffffff8102d6e3>] ? warn_slowpath_common+0x73/0xb0
>  [<ffffffff810210d9>] ? pvclock_clocksource_read+0x49/0x90
>  [<ffffffff812e522f>] ? alloc_arch_preferred_bootmem+0x27/0x45
>  [<ffffffff812e5761>] ? ___alloc_bootmem_nopanic+0x39/0xc9
>  [<ffffffff812e57fa>] ? ___alloc_bootmem+0x9/0x2f
>  [<ffffffff812e9e21>] ? xen_init_IRQ+0x25/0x61
>  [<ffffffff812d69ee>] ? start_kernel+0x1b5/0x29e
> ---[ end trace 4eaa2a86a8e2da22 ]---
[...]

(I myself forgot to put this warning into my initial message too)


Thanks for the fast response and the fix!

Christian.
-- 
BOFH excuse #65:

system needs to be rebooted
