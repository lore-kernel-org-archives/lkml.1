Return-Path: <linux-kernel-owner+w=401wt.eu-S1161849AbXDYIQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161849AbXDYIQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161851AbXDYIQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:16:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4127 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161849AbXDYIQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:16:19 -0400
Date: Wed, 25 Apr 2007 08:16:02 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mark Lord <lkml@rtr.ca>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Con Kolivas <kernel@kolivas.org>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070425081602.GA7255@ucw.cz>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <Pine.LNX.4.61.0704211913130.9989@yvahk01.tjqt.qr> <20070421190026.GA25720@elte.hu> <462B60A1.1020407@rtr.ca> <20070422132732.GB18471@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070422132732.GB18471@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> it into some xorg.conf field. (It also makes sure that X isnt preempted 
> by other userspace stuff while it does timing-sensitive operations like 
> setting the video modes up or switching video modes, etc.)

X is priviledged. It can just cli around the critical section.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
