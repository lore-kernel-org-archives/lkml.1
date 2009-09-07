Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbZIGX5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbZIGX5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 19:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbZIGX5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 19:57:15 -0400
Received: from ee.oulu.fi ([130.231.61.23]:58682 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZIGX5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 19:57:15 -0400
X-Greylist: delayed 1962 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 19:57:14 EDT
Date: Tue, 8 Sep 2009 02:24:15 +0300
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Buesch <mb@bu3sch.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907232415.GA17182@ee.oulu.fi>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <200909072051.13748.mb@bu3sch.de> <20090907205701.GA8590@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090907205701.GA8590@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 10:57:01PM +0200, Ingo Molnar wrote:
> > > Could you profile it please? Also, what's the context-switch rate?
> > 
> > As far as I can tell, the broadcom mips architecture does not have 
> > profiling support. It does only have some proprietary profiling 
> > registers that nobody wrote kernel support for, yet.
> Well, what does 'vmstat 1' show - how many context switches are 
> there per second on the iperf server? In theory if it's a truly 
> saturated box, there shouldnt be many - just a single iperf task 
Yay, finally something that's measurable in this thread \o/

Gigabit Ethernet iperf on an Atom or so might be something that 
shows similar effects yet is debuggable. Anyone feel like taking a shot?

That beast doing iperf probably ends up making it go quite close to it's
limits (IO, mem bw, cpu). IIRC the routing/bridging performance is
something like 40Mbps (depends a lot on the model, corresponds pretty
well with the Mhz of the beast). 

Maybe not totally unlike what make -j16 does to a 1-4 core box? 


