Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbZH0HQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbZH0HQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZH0HQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:16:02 -0400
Received: from mail.gmx.net ([213.165.64.20]:58685 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751361AbZH0HQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:16:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/c3L80BPvc8PXh2UIEhhlEDTWd3/zFoXtfsxmkBa
	m18gj2R2PJh+HJ
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, riel@redhat.com,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
References: <4A943A00.9080609@nortel.com> <1251264700.7538.1178.camel@twins>
	 <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>
	 <1251300625.18584.18.camel@twins>
	 <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
	 <1251302598.18584.31.camel@twins>
	 <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
	 <20090826180407.GA13632@elte.hu>
	 <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 09:15:56 +0200
Message-Id: <1251357356.7051.97.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 15:15 -0400, Christoph Lameter wrote:

> The point of the OFFLINE scheduler is to completely eliminate the
> OS disturbances by getting rid of *all* OS processing on some cpus.

No, that's not the point of OFFSCHED.  It's about offloading kernel
functionality to a peer, and as it currently exists after some years of
development. kernel functionality only.  Raz has already stated that
hard RT is not the point.

<quote> (for full context, jump back a bit in this thread)
> On the other hand, I could see this as a jump platform for more
> proprietary code, something like that: we use linux in out server
> platform, but out "insert buzzword here" network stack pro+ can handle
> 100% more load that linux does, and it runs on a dedicated core....
> 
> In the other words, we might see 'firmwares' that take an entire cpu
for
> their usage.
This is exactly what offsched (sos) is. you got it. SOS was partly
inspired by the notion of a GPU. 
Processors are to become more and more redundant and Linux as an
evolutionary system must use it. why not offload raid5 write engine ?
why not encrypt in a different processor ?
Also , having so many processors in a single OS means a bug prone
system , with endless contention points when two or more OS processors
interacts. let's make things simpler.
</quote>

	-Mike

