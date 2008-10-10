Return-Path: <linux-kernel-owner+w=401wt.eu-S1763157AbYJJW4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763157AbYJJW4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbYJJW4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:56:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201AbYJJWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:55:48 -0400
Date: Fri, 10 Oct 2008 15:54:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: ying.huang@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       tglx@linutronix.de, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH -mm -v5] Separate atomic_t declaration from asm/atomic.h
 into asm/atomic_def.h
Message-Id: <20081010155450.094288b4.akpm@linux-foundation.org>
In-Reply-To: <20081010214958.GA7708@elte.hu>
References: <1223459070.5872.167.camel@yhuang-dev.sh.intel.com>
	<20081010144335.65d8153b.akpm@linux-foundation.org>
	<20081010214958.GA7708@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 23:49:58 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 08 Oct 2008 17:44:30 +0800
> > Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > From: Huang Ying <ying.huang@intel.com>
> > > 
> > > asm/atomic.h contains both declaration and implementation of atomic_t.  So
> > > there are some implementation related files included in asm/atomic.h.  And
> > > atomic_t is a typedef.  Combination of above makes it impossible to use
> > > atomic_t in files included by atomic.h.  Such as atomic_t can not be used
> > > in linux/kernel.h on i386, because it is included by asm/atomic.h.
> > > 
> > > It is reasonable to separate declaration from implementation.  So a new
> > > file atomic_types.h is added for every architecture to accommodate the
> > > declaration of atomic_t.
> > > 
> > > Includes fixes from Andrew Moton.
> > > 
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > Reviewed-by: Ingo Molnar <mingo@elte.hu>
> > 
> > The difference between what-i-currently-have and what-you-just-sent is
> > below.  It's quite large.
> > 
> > Can you explain this update please?
> 
> i've been giving review feedback to make it all fit into existing 
> namespace concepts better. Should have no change in functionality. (But 
> i have not tested it)
> 

I have a note here that Matthew has proposed a different way of doing
all this.  I don't immediately recall the details.

Can we get a refresh on all of that please?
