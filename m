Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZDJFRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZDJFRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZDJFRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:17:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbZDJFRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:17:39 -0400
Date: Thu, 9 Apr 2009 22:08:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Rientjes <rientjes@google.com>, Hugh Dickins <hugh@veritas.com>,
       Ingo Molnar <mingo@elte.hu>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Mike Waychison <mikew@google.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rohit Seth <rohitseth@google.com>, Edwin <edwintorok@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ying Han <yinghan@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 00/14] filemap and readahead fixes
Message-Id: <20090409220815.22ef8b21.akpm@linux-foundation.org>
In-Reply-To: <20090410045440.GA8937@localhost>
References: <20090407115039.780820496@intel.com>
	<20090409213643.0e80fdcf.akpm@linux-foundation.org>
	<20090410045440.GA8937@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 12:54:40 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Fri, Apr 10, 2009 at 12:36:43PM +0800, Andrew Morton wrote:
> > On Tue, 07 Apr 2009 19:50:39 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > This is a set of fixes and cleanups for filemap and readahead.
> > 
> > Unfortunately page_fault-retry-with-nopage_retry.patch got dropped so
> > the first five patches are no longer applicable.  Patch #11 also died.
> > 
> > Can you please respin the remains against current mainline?
> 
> Do you mean rebase them onto linux-next, bypassing Ying Hans' patches?
> 

Those patches are still several akpm-hours ahead in my backlog queue. 
They don't seem to have generated much attention and someone (ie: you)
had substantial comments which haven't been replied to yet.  So I'd
expect another version to be forthcoming.

But I don't mind either way.  I guess the main question here is: do we
see a need to squeeze any of these things into 2.6.30?

