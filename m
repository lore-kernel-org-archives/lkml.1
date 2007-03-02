Return-Path: <linux-kernel-owner+w=401wt.eu-S2992628AbXCBRKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992628AbXCBRKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992635AbXCBRKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:10:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35028 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992628AbXCBRKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:10:17 -0500
Date: Fri, 2 Mar 2007 09:10:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070302091008.42ae604c.akpm@linux-foundation.org>
In-Reply-To: <1172853148.9213.15.camel@dyn9047017100.beaverton.ibm.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<1172853148.9213.15.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 08:32:28 -0800 Badari Pulavarty <pbadari@gmail.com> wrote:

> On Fri, 2007-03-02 at 03:00 -0800, Andrew Morton wrote:
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> > 
> > 
> > - Quite a lot of less-popular architectures still aren't compiling due
> >   to utrace.  x86, x86_64, powerpc, ia64 and s390 should be OK.
> 
> 
> arch/x86_64/mm/numa.c: In function ‘numa_initmem_init’:
> arch/x86_64/mm/numa.c:530: error: ‘cmdline’ undeclared (first use in
> this function)
> arch/x86_64/mm/numa.c:530: error: (Each undeclared identifier is
> reported only once
> arch/x86_64/mm/numa.c:530: error: for each function it appears in.)
> make[1]: *** [arch/x86_64/mm/numa.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> 

oop.  Can we have the .config please?
