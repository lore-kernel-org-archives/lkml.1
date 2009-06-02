Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZFBT6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZFBT6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZFBT6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:58:34 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:63286 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZFBT6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:58:33 -0400
Date: Tue, 2 Jun 2009 15:51:32 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
Message-ID: <20090602195132.GL3914@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <npiggin@suse.de>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu> <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de> <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think> <alpine.LFD.2.00.0906022100130.3419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906022100130.3419@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A2582C8.01A3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:14:23PM +0200, Thomas Gleixner wrote:
> On Tue, 2 Jun 2009, Chris Mason wrote:
> > I'm not suggesting we should take broken code, or that we should lower
> > standards just for xen.  But, expecting the xen developers to fix the 1%
> > hit on a very specific micro-benchmark is not a way to promote new
> > projects for the kernel, and it isn't a good way to convince people to
> > do continued development in mainline instead of in private trees.
> > 
> > Please reconsider.  Keeping these patches out is only making it harder
> > on the people that want to make them better.
> 
> You are missing one subtle point. 
> 

I'm sure I'm missing many more than one ;)

> I read several times, that A, B and C can not be changed design wise
> to allow newer kernels to run on older hypervisors. That's what
> frightens me:
> 
>    dom0 imposes a kind of ABI which we can not change anymore. 
> 
> So where is the room for the improvements which you expect when dom0
> is merged ? It's not about micro benchmark results, it's about the
> inability to fix the existing design decisions in the near future.
> 
> You can change the internals of btrfs as often as you want, but you
> can not change the on disk layout at will. And while you can invent
> btrfs2 w/o any impact aside of grumpy users and a couple of thousand
> lines self contained code, dom0v2 would just add a different layer of
> intrusiveness into the x86 code base w/o removing the existing one.

Well, if there's a line we want to draw in the sand based on firm and
debatable criteria, great.

The problem I see here is that our line in the sand for the xen
developers is fuzzy and winding (yeah, I saw Linus' reply in the other
thread, full ack on that).

-chris

