Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab0BCPro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:47:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:59524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab0BCPrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:47:43 -0500
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Jamie Lokier <jamie@shareable.org>, Roland Dreier <rdreier@cisco.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20100203074251.e2caa3f3.akpm@linux-foundation.org>
References: <20100130094515.475881280@intel.com>
	 <20100130094957.692671259@intel.com>
	 <20100201124825.cc024f2a.akpm@linux-foundation.org>
	 <20100203133951.GA24357@localhost>
	 <20100203070825.e36b3932.akpm@linux-foundation.org>
	 <1265210157.24455.646.camel@laptop>
	 <20100203074251.e2caa3f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 16:47:34 +0100
Message-ID: <1265212054.24455.680.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 07:42 -0800, Andrew Morton wrote:
> On Wed, 03 Feb 2010 16:15:57 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2010-02-03 at 07:08 -0800, Andrew Morton wrote:
> > > On Wed, 3 Feb 2010 21:39:51 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > Is there an official lowest GCC version that Linux supports?
> > > 
> > > Documentation/Changes says gcc-3.2.
> > 
> > Anyway, its not like that macro I used isn't straight forward. Not much
> > a builtin can do better.
> > 
> > The only benefit the builtin has is possibly use machine popcnt
> > instructions but we already deal with that in the kernel.
> 
> We didn't deal with it on every architecture, which is something which
> the compiler extension takes care of.
> 
> In fact I can't find anywhere where we dealt with it on x86.

>From what I know the popcnt ins on x86 is relatively new, hpa was going
to look at supporting it using alternatives.

