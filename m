Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZELP5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZELP5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZELP5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:57:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:45808 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381AbZELP5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:57:04 -0400
Date: Tue, 12 May 2009 17:57:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: uses of cmpxchg/xadd in spinlock.h and rwsem.h vs. CONFIG_M386
Message-ID: <20090512155702.GB31131@wotan.suse.de>
References: <4A09AF8402000078000007DC@vpn.id2.novell.com> <4A099AF0.8020001@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A099AF0.8020001@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 08:51:12AM -0700, H. Peter Anvin wrote:
> Jan Beulich wrote:
> > While looking at a completely different issue I happened to grep for uses of
> > xadd, and it would appear to me that there got uses added that would make
> > a M386-configured SMP kernel die on an actual i386.
> > 
> > Oh, for the rwsem case I see - it would use the RWSEM_GENERIC_SPINLOCK case
> > when selecting M386. But I see nothing similar for the ticket spinlocks - am
> > I overlooking something?
> 
> It's quite possible we break 386 on a regular basis... I'm not sure how
> many people even in the embedded industry run current kernels on
> 386-compatible hardware.  Most embedded hardware is at least 486.

Is it time to get rid of attempts to support SMP kernels that run on 386, then?
Considering we don't actually support SMP 386, and if there is any 386 systems
then they're going to be running custom kernels anyway.


