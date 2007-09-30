Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbXI3L7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbXI3L7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 07:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbXI3L67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 07:58:59 -0400
Received: from mail.suse.de ([195.135.220.2]:44377 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbXI3L66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 07:58:58 -0400
Date: Sun, 30 Sep 2007 13:58:55 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch] i386: remove comment about barriers
Message-ID: <20070930115854.GA7697@wotan.suse.de>
References: <20070929132848.GA21169@wotan.suse.de> <20070930031647.GG9119@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070930031647.GG9119@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 08:16:47PM -0700, Paul E. McKenney wrote:
> On Sat, Sep 29, 2007 at 03:28:48PM +0200, Nick Piggin wrote:
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

Thanks v much for confirming, everyone.


> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > 
> > ---
> > Index: linux-2.6/include/asm-i386/system.h
> > ===================================================================
> > --- linux-2.6.orig/include/asm-i386/system.h
> > +++ linux-2.6/include/asm-i386/system.h
> > @@ -214,11 +214,6 @@ static inline unsigned long get_limit(un
> >   */
> >   
> > 
> > -/* 
> > - * Actually only lfence would be needed for mb() because all stores done 
> > - * by the kernel should be already ordered. But keep a full barrier for now. 
> > - */
> > -
> >  #define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
> >  #define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
> > 
