Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYJOWcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYJOWcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYJOWcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:32:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbYJOWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:32:06 -0400
Date: Wed, 15 Oct 2008 15:31:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: mingo@elte.hu, ying.huang@intel.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH -mm -v5] Separate atomic_t declaration from asm/atomic.h
 into asm/atomic_def.h
Message-Id: <20081015153124.c560e97e.akpm@linux-foundation.org>
In-Reply-To: <20081015221947.GN15064@parisc-linux.org>
References: <1223459070.5872.167.camel@yhuang-dev.sh.intel.com>
	<20081010144335.65d8153b.akpm@linux-foundation.org>
	<20081010214958.GA7708@elte.hu>
	<20081010155450.094288b4.akpm@linux-foundation.org>
	<20081014184718.GG15064@parisc-linux.org>
	<20081015151119.493ea13f.akpm@linux-foundation.org>
	<20081015221947.GN15064@parisc-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 16:19:48 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Oct 15, 2008 at 03:11:19PM -0700, Andrew Morton wrote:
> > On Tue, 14 Oct 2008 12:47:19 -0600
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > > Roman Zippel did me one better and suggested just putting it in types.h,
> > > which works for me.
> > 
> > OK.  Or we could do the usual include/asm-generic/atomic_types.h and
> > then architectures can choose to include that if it is appropriate.
> > 
> > Anyway the good news is that this concept is an addition to rather than
> > a replacement of this current patch.
> 
> Um, no.  Roman and I are against the creation of a new file.  Just put
> the atomic_t definition in <linux/types.h>.

Well we've been glacially fartarsing around with this for sufficiently
long that any such alterations will be too late for 2.6.28.

I'll drop it all.  Again.
