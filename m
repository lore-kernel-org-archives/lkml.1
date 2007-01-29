Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbXA2K1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbXA2K1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXA2K1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:27:13 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:60685
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbXA2K1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:27:13 -0500
Date: Mon, 29 Jan 2007 02:26:51 -0800
To: Ingo Molnar <mingo@elte.hu>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@hill9.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: lockmeter
Message-ID: <20070129102651.GA6943@gnuppy.monkey.org>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128152404.GB9196@elte.hu> <45BCD4C9.2030302@mbligh.org> <20070128170407.GA1526@infradead.org> <45BCDF88.2020504@mbligh.org> <20070128180132.GA1647@gnuppy.monkey.org> <20070128211705.GA9596@elte.hu> <20070129052745.GA5218@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129052745.GA5218@gnuppy.monkey.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 09:27:45PM -0800, Bill Huey wrote:
> On Sun, Jan 28, 2007 at 10:17:05PM +0100, Ingo Molnar wrote:
> > btw., while my plan is to prototype your lock-stat patch in -rt 
> > initially, it should be doable to extend it to be usable with the 
> > upstream kernel as well.
...
> Fantastic. I'm going to try and finish up your suggested changes tonight
> and get it to work with CONFIG_LOCK_STAT off. It's been challenging to
> find time to do Linux these days, so I don't mind handing it off to you
> after this point so that you and tweek it to your heart's content.

Ingo,

Got it.
	http://mmlinux.sourceforge.net/public/patch-2.6.20-rc6-rt2.1.lock_stat.patch

This compiles and runs with the CONFIG_LOCK_STAT option turned off now
and I believe addresses all of your forementioned concern that you
mentioned. I could have missed a detail here and there, but I think
it's in pretty good shape now.

bill

