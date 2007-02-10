Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbXBJKXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbXBJKXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 05:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXBJKXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 05:23:17 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:27783 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbXBJKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 05:23:16 -0500
Date: Sat, 10 Feb 2007 11:22:05 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Davide Libenzi <davidel@xmailserver.org>, ralf@linux-mips.org,
       linux-mips@linux-mips.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070210102205.GB8145@osiris.boeblingen.de.ibm.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org> <1171058342.29713.136.camel@pmac.infradead.org> <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 02:50:12PM -0800, Davide Libenzi wrote:
> On Fri, 9 Feb 2007, David Woodhouse wrote:
> 
> > On Fri, 2007-02-09 at 13:45 -0800, Andrew Morton wrote:
> > > > I would strongly recommend that in the general case, you don't merge new
> > > > system calls unless the corresponding compat_ system call is
> > > > implemented.
> > > 
> > > Good point. 
> > 
> > It's a _damn_ good point, but I see we went ahead and merged
> > sys_epoll_pwait without it anyway -- despite the fact that it's
> > include/linux/eventpoll.h which contains the example of why we should
> > think first :)
> > 
> > I think I even threw together an untested implementation of
> > compat_sys_epoll_pwait() at one point to assist with that task, but it
> > didn't seem to help much.
> 
> Damn! I always forget. Doing it right now ...

Which remembers me that I think that MIPS is using the non-compat version
of sys_epoll_pwait for compat syscalls. But maybe MIPS doesn't need a compat
syscall for some reason. Dunno.
