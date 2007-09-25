Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXIYPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXIYPXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXIYPXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:23:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:22555 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbXIYPXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:23:04 -0400
Subject: Re: [git] CFS-devel, latest code
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070925064522.GA1568@elte.hu>
References: <20070924214537.GA18980@elte.hu>
	 <1190678882.2634.1.camel@imap.mvista.com>  <20070925064522.GA1568@elte.hu>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 08:17:53 -0700
Message-Id: <1190733473.2634.11.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 08:45 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Mon, 2007-09-24 at 23:45 +0200, Ingo Molnar wrote:
> > > Lots of scheduler updates in the past few days, done by many people. 
> > > Most importantly, the SMP latency problems reported and debugged by
> > > Mike 
> > > Galbraith should be fixed for good now. 
> > 
> > Does this have anything to do with idle balancing ? I noticed some 
> > fairly large latencies in that code in 2.6.23-rc's ..
> 
> any measurements?

Yes, I made this a while ago,

ftp://source.mvista.com/pub/dwalker/misc/long-cfs-load-balance-trace.txt

This was with PREEMPT_RT on btw, so it's not the most recent kernel. I
was able to reproduce it in all the -rc's I tried.

Daniel

