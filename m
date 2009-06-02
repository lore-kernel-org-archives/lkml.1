Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZFBQ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZFBQ1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZFBQ1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:27:08 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:45713 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZFBQ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:27:07 -0400
Date: Tue, 2 Jun 2009 12:20:08 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
Message-ID: <20090602162008.GH3914@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <npiggin@suse.de>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu> <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de> <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think> <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com> <20090602150339.GF3914@think> <a36005b50906020822m33917c6fn5061af562b54c6c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a36005b50906020822m33917c6fn5061af562b54c6c2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A25513E.023D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 08:22:57AM -0700, Ulrich Drepper wrote:
> On Tue, Jun 2, 2009 at 8:03 AM, Chris Mason <chris.mason@oracle.com> wrote:
> > The idea that people shipping xen aren't interested in performance
> > regressions is really strange to me.
> 
> Why?  They have a different base line.  For them any regression to
> bare hardware performance is even a positive (since it means the gap
> between hardware and virt shrinks).

And we would have gotten away with it too if it weren't for you meddling
kids!

> 
> 
> > Dynamic patching is a big wad of duct tape over the problem.
> 
> And what do you call the Xen model?  It's a perfect fit IMO.
> 
> > I'm not saying to take harmful code, I'm saying to take code with a
> > small performance regression under a specific CONFIG_.  Slub regresses
> > more than 1% on database loads, CONFIG_SCHED_GROUPS, the list goes on
> > and on.
> 
> None of those have to be enabled in default kernels.
> 
> 
> > The best place to fix xen is in the kernel.
> 
> No.  The best way to fix things is _on the way into the kernel_.

It all depends on which parts are causing problems.  A 1% performance
hit, under a CONFIG_ that can be disabled?  If maintainers are focusing
on details like this for long term and active projects, we're doing
something very wrong.

-chris

