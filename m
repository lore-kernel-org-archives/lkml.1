Return-Path: <linux-kernel-owner+w=401wt.eu-S1765049AbXFEQHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765049AbXFEQHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbXFEQHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:07:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932129AbXFEQHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:07:44 -0400
Date: Tue, 5 Jun 2007 09:07:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] lguest-fix-divide-error-implement-sched_clock
Message-Id: <20070605090714.22bfcfd4.akpm@linux-foundation.org>
In-Reply-To: <200706051624.53157.ak@suse.de>
References: <20070522223828.GV11115@waste.org>
	<200706051201.32137.ak@suse.de>
	<1181049060.14054.30.camel@localhost.localdomain>
	<200706051624.53157.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 16:24:52 +0200 Andi Kleen <ak@suse.de> wrote:

> On Tuesday 05 June 2007 15:11, Rusty Russell wrote:
> > On Tue, 2007-06-05 at 12:01 +0200, Andi Kleen wrote:
> > > > But TSC is a "required feature", so "cpu_has_tsc" is always true.
> > >
> > > Hmm? It isn't. What makes you think so?
> >
> > Interestingly it seems to be only in -mm.
> 
> If it is then it doesn't come out of my tree. Also sounds broken to me.
> The required bits are only for features needed by the compiler's generated
> code where not having them could cause an early crash.
> 

This?

-#define REQUIRED_MASK1 (NEED_PAE|NEED_CMOV|NEED_CMPXCHG64)
+#define REQUIRED_MASK0 (NEED_FPU|NEED_TSC|NEED_PAE|NEED_CMOV|NEED_CX8)

Came in via git-newsetup
