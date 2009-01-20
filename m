Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbZATRsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbZATRsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758398AbZATRsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:48:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49804 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088AbZATRsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:48:11 -0500
Message-ID: <49760E2D.2060109@redhat.com>
Date: Tue, 20 Jan 2009 19:47:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Kevin Shanahan <kmshanah@ucwb.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kevin Shanahan <kmshanah@flexo.wumi.org.au>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_W?= =?ISO-8859-1?Q?eisbecker?= 
	<fweisbec@gmail.com>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera> <1232410363.4768.21.camel@kulgan.wumi.org.au> <20090120113546.GA26571@elte.hu> <1232455343.4895.4.camel@kulgan.wumi.org.au> <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu> <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Note, the wakeup latency only tests realtime threads, since other threads
> can have other issues for wakeup. I could change the wakeup tracer as
> wakeup_rt, and make a new "wakeup" that tests all threads, but it may
> be difficult to get something accurate.
>   

Kevin, can you retest with kvm at realtime priority?

-- 
error compiling committee.c: too many arguments to function

