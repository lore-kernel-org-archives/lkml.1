Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbZKXI56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbZKXI56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbZKXI55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:57:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:47421 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932324AbZKXI54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:57:56 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18DBA8xjLUD7CTL8bIrSjVBQZiXYQWHrtU3NKLKZ8
	DH4uZP3yqqG4Zp
Subject: Re: newidle balancing in NUMA domain?
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1259052035.8843.106.camel@marge.simson.net>
References: <20091123112228.GA2287@wotan.suse.de>
	 <1258987059.6193.73.camel@marge.simson.net>
	 <20091123151152.GA19175@wotan.suse.de> <1258989704.4531.574.camel@laptop>
	 <20091123152931.GD19175@wotan.suse.de>
	 <1258991617.6182.21.camel@marge.simson.net>
	 <20091124065322.GC20981@wotan.suse.de>
	 <1259052035.8843.106.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 09:58:00 +0100
Message-Id: <1259053080.6081.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 09:40 +0100, Mike Galbraith wrote:
> On Tue, 2009-11-24 at 07:53 +0100, Nick Piggin wrote:
> > On Mon, Nov 23, 2009 at 04:53:37PM +0100, Mike Galbraith wrote:
> > > On Mon, 2009-11-23 at 16:29 +0100, Nick Piggin wrote:
> > > 
> > > > So basically about the least well performing or scalable possible
> > > > software architecture. This is exactly the wrong thing to optimise
> > > > for, guys.
> > > 
> > > Hm.  Isn't fork/exec our daily bread?
> > 
> > No. Not for handing out tiny chunks of work and attempting to do
> > them in parallel. There is this thing called Amdahl's law, and if
> > you write a parallel program that wantonly uses the heaviest
> > possible primitives in its serial sections, then it doesn't deserve
> > to go fast.
> 
> OK by me.  A bit if idle time for kbuild is easily cured with telling
> make to emit more jobs, so there's enough little jobs to go around.
> 
> If x264 is declared dainbramaged, that's fine with me too.

(P.S. I don't want to have to explain to users of any such thread happy
applications why they suck rocks under Linux though)

