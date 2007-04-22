Return-Path: <linux-kernel-owner+w=401wt.eu-S1160998AbXDVXPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160998AbXDVXPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161023AbXDVXPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:15:32 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:47302 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160998AbXDVXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:15:08 -0400
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>
Cc: Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
References: <20070420140457.GA14017@elte.hu>
	<200704220155.20856.kernel@kolivas.org>
	<20070421160008.GA28783@elte.hu>
	<200704220959.34978.kernel@kolivas.org>
From: Juliusz Chroboczek <jch@pps.jussieu.fr>
Date: Sun, 22 Apr 2007 15:04:06 +0200
In-Reply-To: <200704220959.34978.kernel@kolivas.org> (Con Kolivas's message of "Sun\, 22 Apr 2007 09\:59\:34 +1000")
Message-ID: <87647oblx5.fsf@pps.jussieu.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh I definitely was not advocating against renicing X,

Why not do it in the X server itself?  This will avoid controversial
policy in the kernel, and have the added advantage of working with
X servers that don't directly access hardware.

Con, if you tell me ``if you're running under Linux and such and such
/sys variable has value so-and-so, then it's definitely a good idea to
call nice(42) at the X server's start up'', then I'll commit it into
X.Org.  (Please CC both me the list, so I can point any people
complaining to the archives.)

                                        Juliusz
