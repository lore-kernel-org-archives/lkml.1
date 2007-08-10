Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbXHJRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbXHJRTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbXHJRTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:19:11 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3513 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbXHJRTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:19:10 -0400
Date: Fri, 10 Aug 2007 19:19:22 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <1186764437.6397.15.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0708101909190.1817@scrub.home>
References: <Pine.LNX.4.64.0708010439050.1817@scrub.home>  <20070801071230.GA16375@elte.hu>
  <Pine.LNX.4.64.0708011511530.1817@scrub.home>  <20070801150742.GA23670@elte.hu>
 <p73ps27npu0.fsf@bingen.suse.de>  <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
  <20070801175004.GA17936@elte.hu>  <Pine.LNX.4.64.0708011955430.1817@scrub.home>
  <20070801190556.GA1199@elte.hu>  <Pine.LNX.4.64.0708100037460.1817@scrub.home>
  <20070810054948.GA5908@elte.hu>  <Pine.LNX.4.64.0708101459530.1817@scrub.home>
 <1186764437.6397.15.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 10 Aug 2007, Mike Galbraith wrote:

> I guess I'm going to have to give up on trying to reproduce this... my
> 3GHz P4 is just not getting there from here.  Last attempt, compiled UP,
> HZ=1000 dynticks, full preempt and highres timers fwiw.
> 
> 6392 root      20   0  1696  332  248 R 25.5  0.0   3:00.14 0 lt
> 6393 root      20   0  1696  332  248 R 24.9  0.0   3:00.15 0 lt
> 6391 root      20   0  1696  488  404 R 24.7  0.0   3:00.20 0 lt
> 6394 root      20   0  2888 1232 1028 R 24.5  0.1   2:58.58 0 sh

Except for UP and HZ=1000, everything else is pretty much turned off.
If you use a very recent kernel, the problem may not be visible like this 
anymore.
It may be a bit easier to reproduce, if you change the end time t0 in lt.c 
a little. Also try to start the busy loop first.

bye, Roman
