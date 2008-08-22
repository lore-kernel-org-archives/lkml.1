Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYHVULj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYHVULj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYHVULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:11:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39374 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbYHVUL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:11:29 -0400
Subject: Re: [RFC v2][PATCH 1/9] Create trivial sys_checkpoint/sys_restart
	syscalls
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <1219433578.20559.98.camel@nimitz>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0808202302510.17436@takamine.ncl.cs.columbia.edu>
	 <1219433578.20559.98.camel@nimitz>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 13:11:25 -0700
Message-Id: <1219435885.20559.125.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-22 at 12:32 -0700, Dave Hansen wrote:
> On Wed, 2008-08-20 at 23:03 -0400, Oren Laadan wrote:
> > 6/unistd_32.h
> > index d739467..88bdec4 100644
> > --- a/include/asm-x86/unistd_32.h
> > +++ b/include/asm-x86/unistd_32.h
> > @@ -338,6 +338,8 @@
> >   #define __NR_dup3             330
> >   #define __NR_pipe2            331
> >   #define __NR_inotify_init1    332
> > +#define __NR_checkpoint                333
> > +#define __NR_restart           334
> > 
> >   #ifdef __KERNEL__
> 
> Uh oh.  These got whitespace mangled somehow.  I'll look through them,
> but probably can't produce patches on top of them for now.

This patch also has to go *AFTER* you actually define the syscall
functions.  Otherwise, this won't be build-bisectable when it gets
committed.

-- Dave

