Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbXFDT2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbXFDT2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbXFDT2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:28:17 -0400
Received: from waste.org ([66.93.16.53]:56933 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758470AbXFDT2Q (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:28:16 -0400
Date: Mon, 4 Jun 2007 14:27:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070604192755.GI11115@waste.org>
References: <20070604173710.GR11166@waste.org> <20070604181151.GA1745@elte.hu> <20070604184224.GH11115@waste.org> <20070604191229.GA12444@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604191229.GA12444@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 09:12:29PM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > > btw., does this only happen with lguest, or with other idle shells 
> > > too?
> > 
> > Only noticed with lguest.
> 
> ah, so both the shell and the 'competing' CPU hog was running within the 
> same lguest instance?

No.

The CPU hog is running in the host. A single instance of lguest using
busybox is started in another shell. When it reaches a shell prompt,
-that- shell is occassionally unresponsive for long stretches.

For the purposes of CFS, of course, the shell running inside lguest is
invisible.

Also, for comparison, running the same kernel and disk image inside
qemu doesn't show any lag, despite being substantially slower (no
kernel/VT acceleration).

-- 
Mathematics is the supreme nostalgia of our time.
