Return-Path: <linux-kernel-owner+w=401wt.eu-S1161712AbXDYNcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161712AbXDYNcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161725AbXDYNcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:32:21 -0400
Received: from avas-mr10.fibertel.com.ar ([24.232.0.223]:42971 "EHLO
	avas-mr10.fibertel.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161712AbXDYNcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:32:21 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 09:32:21 EDT
Message-ID: <462F52AF.6080301@vialibre.org.ar>
Date: Wed, 25 Apr 2007 10:07:59 -0300
From: Federico Heinz <fheinz@vialibre.org.ar>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
References: <20070418211632.GA7610@elte.hu>	<200704182357.28107.mail@earthworm.de>	<20070418220228.GA14536@elte.hu>	<1176947576.5906.21.camel@nigel.suspend2.net>	<20070419070437.GA25211@elte.hu>	<20070424202336.GC16503@elf.ucw.cz>	<alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>	<20070424212408.GD16457@elf.ucw.cz>	<alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>	<20070425064137.GA25247@elte.hu> <20070425072904.GB6866@ucw.cz>
In-Reply-To: <20070425072904.GB6866@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Fib-Al-Info: Al
X-Fib-Al-MRId: 6cfea8bddd5a00a1e1baf9632452893f
X-Fib-Al-SA: analyzed
X-Fib-Al-From: fheinz@vialibre.org.ar
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> ..and it means that 'echo disk > ...' should work w/o suspend2 patch,
> too. (Just try it). You'll miss compression part, but that provides
> only small speedup.
>   

In my experience, the speedup is significant, both in hibernating and in 
waking up, and since the full image is written to disk, the system wakes 
up *usable*. It takes forever for a system that wakes up from uswsusp to 
be usable again, it keeps tripping over page faults for *minutes*.

    Fede

