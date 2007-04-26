Return-Path: <linux-kernel-owner+w=401wt.eu-S1031508AbXDZVG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031508AbXDZVG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031511AbXDZVG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:06:56 -0400
Received: from thunk.org ([69.25.196.29]:55865 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031508AbXDZVGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:06:55 -0400
Date: Thu, 26 Apr 2007 17:06:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Johannes Berg <johannes@sipsolutions.net>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426210631.GD24852@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>,
	Johannes Berg <johannes@sipsolutions.net>,
	Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz> <1177585897.6814.49.camel@johannes.berg> <20070426111645.GR17387@elf.ucw.cz> <1177586850.6814.52.camel@johannes.berg> <20070426112641.GS17387@elf.ucw.cz> <alpine.LFD.0.98.0704260855380.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704260855380.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 08:56:48AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 26 Apr 2007, Pavel Machek wrote:
> > 
> > Yes, probably will. The other option is to break existing 32-bit
> > userspace, which is a bit more common AFAICT.
> 
> And *this* is why kernel/userspace things simply should not be done.
> 
> It's simply better to do things entirely in the kernel. Because you add 
> bugs and complications otherwise, and doing it in the kernel allows you 
> to just switch things around.
> 
> As it is, it appears that user-space suspend is just broken whichever way 
> we turn.

Well, in that case maybe suspend2 should be very seriously considered,
since it has the features of uswsusp --- basic features which every
single Microsoft and MacOSX user are used to like, like progress bars
--- and it's all done in the kernel.

					- Ted

