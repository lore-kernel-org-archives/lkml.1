Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbXLKTDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbXLKTDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXLKTDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:03:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbXLKTDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:03:37 -0500
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
	[2.6.24-rc4-git5: Reported regressions from 2.6.23]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20071211085232.GE20172@elte.hu>
References: <200712080340.49546.rjw@sisk.pl>
	 <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org>
	 <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
	 <20071208100950.a3547868.akpm@linux-foundation.org>
	 <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
	 <20071208195211.GA3727@elte.hu> <20071211062720.GA29764@redhat.com>
	 <20071211085232.GE20172@elte.hu>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 20:03:01 +0100
Message-Id: <1197399781.6353.60.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-11 at 09:52 +0100, Ingo Molnar wrote:
> * Dave Jones <davej@redhat.com> wrote:

> > Which leaves my only other gripe.  It broke slabtop.
> 
> that's actually a _bad_ ABI regression. Rafael, could you please add 
> this to the regressions list?
> 
> > There's an alternative implementation in Documentation/vm/slabinfo.c 
> > (why there not say, util-linux, home of current slabtop?)
> 
> the kernel should output /proc/slabinfo data with the same formatting, 
> period.

I can remember it being said that would be one of the things to-do
before SLUB could become default.

