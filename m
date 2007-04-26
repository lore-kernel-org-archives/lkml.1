Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbXDZL0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbXDZL0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXDZL0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:26:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33329 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754649AbXDZL0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:26:53 -0400
Date: Thu, 26 Apr 2007 13:26:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426112641.GS17387@elf.ucw.cz>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz> <1177585897.6814.49.camel@johannes.berg> <20070426111645.GR17387@elf.ucw.cz> <1177586850.6814.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177586850.6814.52.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This one should prevent ioctl numbers changing, too.
> 
> > -#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, void *)
> > +#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, u32) /* void * */
> 
> Afaict that'll actually change ioctl numbers breaking existing 64-bit
> userspace.

Yes, probably will. The other option is to break existing 32-bit
userspace, which is a bit more common AFAICT.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
