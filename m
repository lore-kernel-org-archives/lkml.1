Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYFBWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYFBWgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYFBWgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:36:06 -0400
Received: from smtprelay11.ispgateway.de ([80.67.29.28]:43929 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYFBWgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:36:04 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Paul Jackson <pj@sgi.com>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Date: Tue, 3 Jun 2008 00:35:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Randy.Dunlap" <rddunlap@osdl.org>, suresh.b.siddha@intel.com,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080601213019.14ea8ef8.pj@sgi.com>
In-Reply-To: <20080601213019.14ea8ef8.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806030035.58387.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

in short: NAK!

On Monday 02 June 2008, Paul Jackson wrote:
> (Aside to the RealTime folks -- is there a 'realtime'
> email list which I should include in this discussion?)
> 
> The kernel has a "isolcpus=" kernel boot time parameter.  This
> parameter isolates CPUs from scheduler load balancing, minimizing the
> impact of scheduler latencies on realtime tasks running on those CPUs.

I used it to mask out a defect CPU on a 8-CPU node of a 
HPC-cluster at a customer site, until the $BIG_VENDOR 
sent a replacement. And to prove $BIG_VENDOR, that we actually
have a problem on THAT CPU.

So I would really like to keep this fault isolation capability.
I made my customer happy with that.

I wish Linux had more such "mask out bad hardware" features
to faciliate fault isolation and boot and runtime.


Best Regards

Ingo Oeser
