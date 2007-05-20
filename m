Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXETCpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXETCpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 22:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbXETCph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 22:45:37 -0400
Received: from homer.mvista.com ([63.81.120.158]:40256 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbXETCpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 22:45:36 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Daniel Walker <dwalker@mvista.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <17998.28659.702653.237011@cargo.ozlabs.ibm.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
	 <464C99FF.8080404@ru.mvista.com>
	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
	 <1179500217.20519.53.camel@imap.mvista.com>
	 <464DC0DC.7050809@ru.mvista.com>
	 <1179502773.20519.56.camel@imap.mvista.com>
	 <17998.28659.702653.237011@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Sat, 19 May 2007 19:43:11 -0700
Message-Id: <1179628991.20925.2.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 13:33 +1000, Paul Mackerras wrote: 
> Daniel Walker writes:
> 
> > On Fri, 2007-05-18 at 19:06 +0400, Sergei Shtylyov wrote:
> > >     Well, the decrementer frequency may change, at least in theory (if the bus 
> > > clock changes).
> > 
> > Does that happen very often?
> 
> If it did, gettimeofday would start reporting seriously wrong values,
> since the timebase and the decrementer count at the same rate, and we
> don't have any provision for fixing things up if that rate changed.
> Fortunately there are no powerpc platforms where the rate is
> variable.

In terms of clocksources, gettimeofday() would have to switch to another
clocksource if the decrementer started to act that way .. That's why it
is possible to register more than one clocksource, to allow for the
switching. The decrementer frequency doesn't change even with cpufreq?

Daniel

