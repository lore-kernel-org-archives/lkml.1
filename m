Return-Path: <linux-kernel-owner+w=401wt.eu-S1762614AbZATORN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762614AbZATORN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760964AbZATOO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:14:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:53552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762005AbZATOO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:14:56 -0500
Date: Tue, 20 Jan 2009 15:14:54 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120141454.GI19505@wotan.suse.de>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120140324.GA26424@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 03:03:24PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Times I believe are in nanoseconds for lmbench, anyway lower is 
> > > better.
> > > 
> > > non pv   AVG=464.22 STD=5.56
> > > paravirt AVG=502.87 STD=7.36
> > > 
> > > Nearly 10% performance drop here, which is quite a bit... hopefully 
> > > people are testing the speed of their PV implementations against 
> > > non-PV bare metal :)
> > 
> > Ouch, that looks unacceptably expensive. All the major distros turn 
> > CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the express 
> > promise to have no measurable runtime overhead.
> 
> Here are some more precise stats done via hw counters on a perfcounters 
> kernel using 'timec', running a modified version of the 'mmap performance 
> stress-test' app i made years ago.
> 
> The MM benchmark app can be downloaded from:
> 
>    http://redhat.com/~mingo/misc/mmap-perf.c

BTW. the lmbench test I run directly (it's called lat_mmap.c, and gets
compiled into a standalone lat_mmap exec by the standard lmbench build).

 
