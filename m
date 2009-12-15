Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZLORxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZLORxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759622AbZLORxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:53:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:6085 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759579AbZLORxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:53:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sX7LAg3en0kLXvsG8XmfO79b+KdtmFeJTAl5sE0tFR/JQWuTeEelcK+6Kx2Gu8L519
         VOseqD1/X4w8fPvPlPK9ogITH9ckuZoL9EFjQf45yqPnpck54wj08RSZnGGRGOK8wiw8
         NfE1XWNYbBbsW11bCpa+kCv5J7shCI8mKWViQ=
Date: Tue, 15 Dec 2009 18:53:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Randrianasulu <randrik_a@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: build failure?
Message-ID: <20091215175330.GA8423@nowhere>
References: <930015.68095.qm@web65313.mail.ac2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <930015.68095.qm@web65313.mail.ac2.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 12:37:23AM -0800, Andrew Randrianasulu wrote:
> Hello!
> 
> using master branch from 
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary
> 
> (up to commit 3ea6b3d0e6d0ffd91c0f8cadeb69b7133c038b32
> Merge: 75b0803 2c948b3
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Dec 14 12:50:25 2009 -0800
> 
>     Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6)
> 
> i have strange build failure, anyone saw recently something like this?
> 
> -----------build log----------
>   CC      arch/x86/kernel/pci-nommu.o                 
>   CC      arch/x86/kernel/hw_breakpoint.o             
> In file included from arch/x86/kernel/hw_breakpoint.c:31:
> include/linux/hw_breakpoint.h: In function 'hw_breakpoint_addr':
> include/linux/hw_breakpoint.h:39: error: 'struct perf_event' has no member named 'attr'
> include/linux/hw_breakpoint.h: In function 'hw_breakpoint_type':
> include/linux/hw_breakpoint.h:44: error: 'struct perf_event' has no member named 'attr'
> include/linux/hw_breakpoint.h: In function 'hw_breakpoint_len':
> include/linux/hw_breakpoint.h:49: error: 'struct perf_event' has no member named 'attr'
> include/linux/hw_breakpoint.h: In function 'counter_arch_bp':
> include/linux/hw_breakpoint.h:85: error: 'struct perf_event' has no member named 'hw'
> arch/x86/kernel/hw_breakpoint.c: In function 'arch_build_bp_info':
> arch/x86/kernel/hw_breakpoint.c:280: error: 'struct perf_event' has no member named 'attr'
> arch/x86/kernel/hw_breakpoint.c:283: error: 'struct perf_event' has no member named 'attr'
> arch/x86/kernel/hw_breakpoint.c:303: error: 'struct perf_event' has no member named 'attr'
> arch/x86/kernel/hw_breakpoint.c: In function 'aout_dump_debugregs':
> arch/x86/kernel/hw_breakpoint.c:407: error: 'struct perf_event' has no member named 'attr'
> arch/x86/kernel/hw_breakpoint.c:408: error: 'struct perf_event' has no member named 'attr'
> make[2]: *** [arch/x86/kernel/hw_breakpoint.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2
> make: *** [arch/x86] Error 2
> ------------build log end----
> 
> gcc --version
> gcc (GCC) 4.3.3
> Copyright (C) 2008 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> ---------------------
> 
> 
> my .config (i tried to find minimal, working on 4MB of ram, config for x86 machine)
> 
> ----my .config-----


Thanks. The problem is in some badly written config dependencies I've made.
I'll fix this.

