Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZGNNva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZGNNva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZGNNv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:51:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZGNNv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:51:29 -0400
Date: Tue, 14 Jul 2009 09:51:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.1 - System calls - ioctl
Message-ID: <20090714135120.GA5445@infradead.org>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622114931.GB24366@elte.hu> <20090622125837.GA9429@infradead.org> <1247482393.7529.74.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247482393.7529.74.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 12:53:13PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-06-22 at 08:58 -0400, Christoph Hellwig wrote:
> > But talking about syscalls the sys_perf_counter_open prototype is
> > really ugly - it uses either the pid or cpu argument which is a pretty
> > clear indicator it should actually be two sys calls.
> 
> Would something like the below be any better?
> 
> It would allow us to later add something like PERF_TARGET_SOCKET and
> things like that.
> 
> (utterly untested)

And makes the code a couple of magnitudes more ugly..  If you really
add a completely new targer adding a new system call wouldn't be a big
issue.  Altough a socket seems like a pretty logical flag extension to
the cpu syscall (or sub-syscall currently), as it would still be
specified as trace the whole cpu socket for this given cpuid.

