Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbZJIDFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbZJIDFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbZJIDFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:05:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:38345 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932317AbZJIDFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:05:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ratZkiZbrduZ2bDABIVmzmjn5jGk7DSnExR8E0I
	jiJIMBjLvsbgPs
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200910082259.35204.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	 <200910081655.37485.elendil@planet.nl>
	 <1255026217.6643.12.camel@marge.simson.net>
	 <200910082259.35204.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 05:04:33 +0200
Message-Id: <1255057473.6600.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 22:59 +0200, Frans Pop wrote:
> On Thursday 08 October 2009, Mike Galbraith wrote:
> > I still see very high latencies coming out of idle (last noted was >
> > 300ms, NO_HZ) with this patch,
> >
> > Like this:
> >
> > Cause                                           Maximum    Percentage
> > Scheduler: waiting for cpu                   604.2 msec        49.0 %
> 
> I'm not seeing anything even remotely like that.
> 
> I've tried quieting the system down as much as possible, but that made
> no difference. I do have NO_HZ set; will send my full config privately.
> 
> If you'd still like me to try your patch I will, but I'm not sure if
> that has much value.

No, if you watch for a bit with box mostly idle, and don't see > 100ms
hits occasionally, testing patchlet is likely a waste of time.  To get
one like the above, I have to hold my tongue just right ;-) they're not
common.

	-Mike

