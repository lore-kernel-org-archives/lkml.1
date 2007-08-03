Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbXHCDEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbXHCDEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 23:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbXHCDEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 23:04:35 -0400
Received: from waste.org ([66.93.16.53]:52485 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbXHCDEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 23:04:35 -0400
Date: Thu, 2 Aug 2007 22:04:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070803030436.GO11166@waste.org>
References: <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801112229.GA11710@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801112229.GA11710@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 01:22:29PM +0200, Ingo Molnar wrote:
> 
> * Roman Zippel <zippel@linux-m68k.org> wrote:
> 
> > [...] e.g. in this example there are three tasks that run only for 
> > about 1ms every 3ms, but they get far more time than should have 
> > gotten fairly:
> > 
> >  4544 roman     20   0  1796  520  432 S 32.1  0.4   0:21.08 lt
> >  4545 roman     20   0  1796  344  256 R 32.1  0.3   0:21.07 lt
> >  4546 roman     20   0  1796  344  256 R 31.7  0.3   0:21.07 lt
> >  4547 roman     20   0  1532  272  216 R  3.3  0.2   0:01.94 l
> 
> Mike and me have managed to reproduce similarly looking 'top' output, 
> but it takes some effort: we had to deliberately run a non-TSC 
> sched_clock(), CONFIG_HZ=100, !CONFIG_NO_HZ and !CONFIG_HIGH_RES_TIMERS.

..which is pretty much the state of play for lots of non-x86 hardware.

-- 
Mathematics is the supreme nostalgia of our time.
