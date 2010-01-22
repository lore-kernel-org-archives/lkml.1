Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944Ab0AVUQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0AVUQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 15:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651Ab0AVUQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 15:16:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:38712 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab0AVUQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 15:16:31 -0500
Subject: Re: linux-next: add utrace tree
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100122200129.GG22003@redhat.com>
References: <20100120062834.GB12165@elte.hu>
	 <20100120072925.GA11395@elte.hu>
	 <20100121013822.28781960.sfr@canb.auug.org.au>
	 <20100122111747.3c224dfd.sfr@canb.auug.org.au>
	 <20100121163004.8779bd69.akpm@linux-foundation.org>
	 <20100121163145.7e958c3f.akpm@linux-foundation.org>
	 <20100122005147.GD22003@redhat.com>
	 <20100121170541.7425ff10.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
	 <20100122182827.GA13185@redhat.com>  <20100122200129.GG22003@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 21:16:16 +0100
Message-ID: <1264191376.4283.1590.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 15:01 -0500, Frank Ch. Eigler wrote:
> So then there's uprobes, which is another potential utrace "killer
> app"

That's bollocks, uprobes is an utter and total mis-match for utrace.
Probing userspace is primarily about DSOs which is files and vma's, not
tasks.

You might maybe want a utrace interface to that, but that is largely
non-interesting.

IOW, we don't need utrace to make sensible use of uprobes.

(And when I speak of uprobes I mean the thing formerly called UBP)

