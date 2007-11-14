Return-Path: <linux-kernel-owner+w=401wt.eu-S1763330AbXKNSly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763330AbXKNSly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbXKNSlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:41:46 -0500
Received: from waste.org ([66.93.16.53]:47294 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbXKNSlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:41:46 -0500
Date: Wed, 14 Nov 2007 12:39:52 -0600
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071114183952.GS19691@waste.org>
References: <200711112058.28043.rjw@sisk.pl> <20071114112001.GA13870@elte.hu> <20071114173611.GR19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114173611.GR19691@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 11:36:11AM -0600, Matt Mackall wrote:
> On Wed, Nov 14, 2007 at 12:20:01PM +0100, Ingo Molnar wrote:
> > 
> > there's a new SLOB regression - the attached config crashes with:
> > 
> > [   61.245190] rc.sysinit used greatest stack depth: 1680 bytes left
> > [   61.386859] list_add corruption. prev->next should be next (407d973c), but was 418cf818. (prev=41877098).
> > [   61.396328] ------------[ cut here ]------------
> > [   61.400910] kernel BUG at lib/list_debug.c:33!
> > [   61.405330] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
> > 
> > looks like memory corruption of some sort and it's reproducible. Picking 
> > CONFIG_SLUB makes the crash go away. Booting v2.6.23 with the same 
> > .config works fine.
> 
> Hmmm, the changes in SLOB since v2.6.23 are all trivial. I'll try to
> reproduce it with your config, but it doesn't seem promising.

Couldn't reproduce it here, let me know if you get anywhere with your bisect.

-- 
Mathematics is the supreme nostalgia of our time.
