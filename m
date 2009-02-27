Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZB0JZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZB0JZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbZB0JZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:25:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748AbZB0JZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:25:17 -0500
Date: Fri, 27 Feb 2009 01:22:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, mpm@selenic.com,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, linux-api@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
Message-Id: <20090227012209.65401324.akpm@linux-foundation.org>
In-Reply-To: <20090227090323.GC16211@elte.hu>
References: <20090211141434.dfa1d079.akpm@linux-foundation.org>
	<1234462282.30155.171.camel@nimitz>
	<1234467035.3243.538.camel@calx>
	<20090212114207.e1c2de82.akpm@linux-foundation.org>
	<1234475483.30155.194.camel@nimitz>
	<20090212141014.2cd3d54d.akpm@linux-foundation.org>
	<1234479845.30155.220.camel@nimitz>
	<20090226162755.GB1456@x200.localdomain>
	<20090226173302.GB29439@elte.hu>
	<20090226223112.GA2939@x200.localdomain>
	<20090227090323.GC16211@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 10:03:23 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> >  arch/x86/include/asm/unistd_32.h   |    2 
> >  arch/x86/kernel/syscall_table_32.S |    2 
> >  include/linux/Kbuild               |    1 
> >  include/linux/cr.h                 |   56 ++++++
> >  include/linux/ipc_namespace.h      |    3 
> >  include/linux/syscalls.h           |    5 
> >  init/Kconfig                       |    2 
> >  kernel/Makefile                    |    1 
> >  kernel/cr/Kconfig                  |   11 +
> >  kernel/cr/Makefile                 |    8 
> >  kernel/cr/cpt-cred.c               |  115 +++++++++++++
> >  kernel/cr/cpt-fs.c                 |  122 +++++++++++++
> >  kernel/cr/cpt-mm.c                 |  134 +++++++++++++++
> >  kernel/cr/cpt-ns.c                 |  324 +++++++++++++++++++++++++++++++++++++
> >  kernel/cr/cpt-signal.c             |  121 +++++++++++++
> >  kernel/cr/cpt-sys.c                |  228 ++++++++++++++++++++++++++
> >  kernel/cr/cr-ctx.c                 |  141 ++++++++++++++++
> >  kernel/cr/cr.h                     |   61 ++++++
> >  kernel/cr/rst-sys.c                |    9 +
> >  kernel/sys_ni.c                    |    3 
> >  20 files changed, 1349 insertions(+)
> 
> That does not look scary to me at all. Andrew?

btw, why is there no need for a kernel/cr/cpt-net.c?
