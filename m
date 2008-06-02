Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbYFBWtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbYFBWtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYFBWsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:48:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36583 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYFBWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:48:54 -0400
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
	have realtime uses)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200806030035.58387.ioe-lkml@rameria.de>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	 <200806030035.58387.ioe-lkml@rameria.de>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 00:45:07 +0200
Message-Id: <1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 00:35 +0200, Ingo Oeser wrote:
> Hi Paul,
> 
> in short: NAK!
> 
> On Monday 02 June 2008, Paul Jackson wrote:
> > (Aside to the RealTime folks -- is there a 'realtime'
> > email list which I should include in this discussion?)
> > 
> > The kernel has a "isolcpus=" kernel boot time parameter.  This
> > parameter isolates CPUs from scheduler load balancing, minimizing the
> > impact of scheduler latencies on realtime tasks running on those CPUs.
> 
> I used it to mask out a defect CPU on a 8-CPU node of a 
> HPC-cluster at a customer site, until the $BIG_VENDOR 
> sent a replacement. And to prove $BIG_VENDOR, that we actually
> have a problem on THAT CPU.
> 
> So I would really like to keep this fault isolation capability.
> I made my customer happy with that.
> 
> I wish Linux had more such "mask out bad hardware" features
> to faciliate fault isolation and boot and runtime.

Yeah - except that its not meant to be used as such - it will still
brings the cpu up, and it is still usable for the OS.

So sorry, your abuse doesn't make for a case to keep this abomination.

