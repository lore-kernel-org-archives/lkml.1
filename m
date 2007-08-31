Return-Path: <linux-kernel-owner+w=401wt.eu-S965209AbXHaNW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965209AbXHaNW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964971AbXHaNWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:22:20 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2235 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879AbXHaNWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:22:19 -0400
Date: Fri, 31 Aug 2007 15:22:52 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Mike Galbraith <efault@gmx.de>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <1188553015.8061.36.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0708311520420.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
 <1188553015.8061.36.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 31 Aug 2007, Mike Galbraith wrote:

> I plunked it into 2.6.23-rc4 to see how it reacts to various sleeper
> loads, and hit some starvation.  If I got it in right (think so) there's
> a bug lurking somewhere.  taskset -c 1 fairtest2 resulted in the below.
> It starts up running both tasks at about 60/40 for hog/sleeper, then
> after a short while goes nuts.  The hog component eats 100% cpu and
> starves the sleeper (and events, forever).

Thanks for testing, although your test program does nothing unusual here.
Can you please send me your .config?
Were there some kernel messages while running it?

bye, Roman

