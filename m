Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbZFOTEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbZFOTEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933740AbZFOTE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:04:29 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48237 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933426AbZFOTE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:04:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAA43NkpMQWQl/2dsb2JhbACBT9U+hA0F
Date: Mon, 15 Jun 2009 14:59:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, efault@gmx.de, jeremy@goop.org,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615185907.GF6520@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1245091917.6741.185.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:57:04 up 107 days, 15:23,  3 users,  load average: 0.27, 0.56,
	0.81
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Mon, 2009-06-15 at 14:48 -0400, Mathieu Desnoyers wrote:
> > we should not care that much about the performance hit of
> > saving/restoring the cr2 register at each nmi entry/exit.
> 
> But we do, perf counters very much cares about nmi performance.
> 

To a point where it cannot afford a simple register save/restore ?

There is "caring" and "_caring_". I am tempted to ask what NMI handler
execution frequency you have in mind here to figure out if we are not
trying to optimize sub-nanoseconds per minutes. ;)

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
