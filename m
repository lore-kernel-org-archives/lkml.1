Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0BWUVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:21:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab0BWUVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:21:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Fcc: ~/Mail/linus
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       linux-tip-commits@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: linux-next requirements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
In-Reply-To: Stephen Rothwell's message of  Tuesday, 23 February 2010 10:59:59 +1100 <20100223105959.a50dbe11.sfr@canb.auug.org.au>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
	<20100222090710.GA31357@elte.hu>
	<20100222203319.8bd497a2.sfr@canb.auug.org.au>
	<20100222102745.GJ20844@elte.hu>
	<20100222224752.0cbd5807.sfr@canb.auug.org.au>
	<4B830BD8.3090600@zytor.com>
	<20100223105959.a50dbe11.sfr@canb.auug.org.au>
X-Zippy-Says: Is this BOISE??
Message-Id: <20100223202030.44DED64C@magilla.sf.frob.com>
Date: Tue, 23 Feb 2010 12:20:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are there any downsides to Roland's patch as far as PARISC is concerned
> (apart from the loss of some functionality, of course)?

Kyle ACK'd my parisc patch, and my impression is he wants it to go in
and does not plan to work on the necessary arch support imminently.

I think the only visible effect of turning off HAVE_ARCH_TRACEHOOK
on parisc will be that /proc/pid/syscall is not available.


Thanks,
Roland
