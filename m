Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZAaFiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZAaFiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 00:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbZAaFiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 00:38:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:44702 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750853AbZAaFiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 00:38:09 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/HTGsU6nHHMA9i9oHAP6NGi6mkanBSv5x93SiiHS
	nmcfdF4JeABbcL
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Mike Galbraith <efault@gmx.de>
To: Brian Rogers <brian@xyzw.org>
Cc: Nathanael Hoyle <nhoyle@hoyletech.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       stable <stable@kernel.org>
In-Reply-To: <49837B32.3010206@xyzw.org>
References: <1233294584.28741.2.camel@localhost>
	 <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>
	 <1233297635.17301.11.camel@localhost>
	 <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr>
	 <1233302349.17301.27.camel@localhost>
	 <1233302861.6061.14.camel@marge.simson.net>  <49837B32.3010206@xyzw.org>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 06:38:04 +0100
Message-Id: <1233380284.5636.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 14:12 -0800, Brian Rogers wrote:
> Mike Galbraith wrote:
> > On Fri, 2009-01-30 at 02:59 -0500, Nathanael Hoyle wrote:
> >   
> >> I am running foldingathome under it at the moment, and it seems to be
> >> improving the situation somewhat, but I still need/want to test with
> >> Mike's referenced patches.
> >>     
> > You will most definitely encounter evilness running SCHED_IDLE tasks in
> > a kernel without the SCHED_IDLE fixes.
> >   
> Speaking of SCHED_IDLE fixes, is 
> 6bc912b71b6f33b041cfde93ca3f019cbaa852bc going to be put into the next 
> stable 2.6.28 release? Without it on 2.6.28.2, I can still produce 
> minutes-long freezes with BOINC or other idle processes.
> 
> With the above commit on top of 2.6.28.2 and also 
> cce7ade803699463ecc62a065ca522004f7ccb3d, the problem is solved, though 
> I assume cce7ad isn't actually required to fix that, and I can test that 
> if desired.

I think they both should go to stable, but dunno if they're headed that
direction or not.

One way to find out, CCs added.

	-Mike

