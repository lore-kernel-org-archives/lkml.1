Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbXDZVaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbXDZVaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXDZVaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:30:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57103 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753144AbXDZVac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:30:32 -0400
Date: Thu, 26 Apr 2007 23:30:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Olivier Galibert <galibert@pobox.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426213012.GE21695@elf.ucw.cz>
References: <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426103051.GP17387@elf.ucw.cz> <1177585458.6814.45.camel@johannes.berg> <20070426110953.GQ17387@elf.ucw.cz> <20070426182120.GA81126@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426182120.GA81126@dspnet.fr.eu.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > #define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, unsigned long)
> 
> So I'm not supposed to be able to suspend the 16Gb-ram, 32bits servers
> I have here?

(You are right, this should have been u64)

Snapshot image is by design limited by ammount of lowmem. If you want
to change that, this unsigned long limit will be least of your
problems.

(And no, I'd not expect loaded 6GB box to suspend properly. It will
just realize it does not have enough lowmem and refuse to suspend).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
