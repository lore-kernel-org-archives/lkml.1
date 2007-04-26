Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXDZLgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXDZLgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030668AbXDZLgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:36:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33369 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbXDZLgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:36:53 -0400
Date: Thu, 26 Apr 2007 12:35:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426113525.GA1332@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Machek <pavel@ucw.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>
References: <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177582633.6814.29.camel@johannes.berg>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 12:17:12PM +0200, Johannes Berg wrote:
> On Tue, 2007-04-24 at 23:24 +0200, Pavel Machek wrote:
> 
> > I believe uswsusp user/kernel separation is clean enough. Kernel
> > provides "snapshot image" and "resume image". (Thanks go to Rafael for
> > very clean interface).
> 
> The interface isn't even 64/32-bit compatible...

It's not .  And it's one of the worst interface I've seen lately.
Did anyone actually review this crap before it went in?  I completely
agree with Linus that these kind of boundaries that lead to horribly
complex ioctl interface are totally wrong.

Now suspend2 wasn't exactly nice either when I last reviewed it,
but we should probably give it another attempt if we can sort out
a proper incremental merge.

