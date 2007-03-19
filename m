Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbXCSJaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbXCSJaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbXCSJaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:30:16 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51410 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbXCSJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:30:13 -0400
Date: Mon, 19 Mar 2007 15:00:06 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070319093006.GB12092@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070317163350.6b676c26.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070317163350.6b676c26.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 04:33:50PM +1100, Stephen Rothwell wrote:
> On Fri, 16 Mar 2007 20:01:01 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> >
> 
> > +asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
> >
> > --- linux-2.6.20.1.orig/include/asm-powerpc/systbl.h
> > +++ linux-2.6.20.1/include/asm-powerpc/systbl.h
> > @@ -305,3 +305,4 @@ SYSCALL_SPU(faccessat)
> >  COMPAT_SYS_SPU(get_robust_list)
> >  COMPAT_SYS_SPU(set_robust_list)
> >  COMPAT_SYS(move_pages)
> > +SYSCALL(fallocate)
> 
> It is going to need to be a COMPAT_SYS call in powerpc because 32 bit
> powerpc will pass the two loff_t's in pairs of registers while
> 64bit passes them in one register each.

Ok. Will make that change, unless it is decided to pass each loff_t
argument as two "u32"s. Thanks!

--
Regards,
Amit Arora
