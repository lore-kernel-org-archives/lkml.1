Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZAUOwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZAUOwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbZAUOv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:51:56 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:56357 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbZAUOvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:51:55 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <49773275.3020203@redhat.com>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	 <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>
	 <1232410363.4768.21.camel@kulgan.wumi.org.au>
	 <20090120113546.GA26571@elte.hu>
	 <1232455343.4895.4.camel@kulgan.wumi.org.au>
	 <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu>
	 <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>
	 <49760E2D.2060109@redhat.com>
	 <1232547932.4895.119.camel@kulgan.wumi.org.au>
	 <49773275.3020203@redhat.com>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Thu, 22 Jan 2009 01:21:42 +1030
Message-Id: <1232549502.4895.124.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 16:34 +0200, Avi Kivity wrote:
> Kevin Shanahan wrote:
> > On Tue, 2009-01-20 at 19:47 +0200, Avi Kivity wrote:
> >> Kevin, can you retest with kvm at realtime priority?
...

> > --- hermes-old.wumi.org.au ping statistics ---
> > 900 packets transmitted, 900 received, 0% packet loss, time 899326ms
> > rtt min/avg/max/mdev = 0.093/0.157/3.611/0.117 ms
> >
> > So, a _huge_ difference. But what does it mean?
> 
> It means, a scheduling problem.  Can you run the latency tracer (which 
> only works with realtime priority), so we can tell if it is (a) kvm 
> failing to wake up the vcpu properly or (b) the scheduler delaying the 
> vcpu from running.

Sorry, but are you sure that's going to be useful?

If it only works on realtime threads and I'm not seeing the problem when
running kvm with realtime priority, is this going to tell you what you
want to know?

Not trying to be difficult, but that just didn't make sense to me.

Regards,
Kevin.


