Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXCSQHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXCSQHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030299AbXCSQHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:07:41 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:1365 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030284AbXCSQHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:07:41 -0400
Message-ID: <45FEB54A.3040602@rtr.ca>
Date: Mon, 19 Mar 2007 12:07:38 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com> <200703172048.46267.kernel@kolivas.org> <1174125534.7734.2.camel@Homer.simpson.net> <200703172355.30989.a1426z@gawab.com>
In-Reply-To: <200703172355.30989.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
>..
> Mike, I'm not saying RSDL is perfect, but v0.31 is by far better than 
> mainline.  Try this easy test:
> 
> startx with the vesa driver
> run reflect from the mesa5.0-demos
> load 5 cpu-hogs
> start moving the mouse
> 
> On my desktop, mainline completely breaks down, and no nicing may rescue.
> 
> On RSDL, even without nicing, the desktop is at least useable.

I use a simpler, far more common (for lkml participants) workload:

Dell notebook, single P-M-2GHz, ATI X300, open source X.org:
(1) build a kernel in one window with "make -j$((NUMBER_OF_CPUS + 1))".
(2) try to read email and/or surf in Firefox/Thunderbird.

Stock scheduler wins easily, no contest.

Cheers
