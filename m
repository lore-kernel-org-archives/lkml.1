Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbXLIH7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbXLIH7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 02:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXLIH72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 02:59:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbXLIH71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 02:59:27 -0500
Date: Sun, 9 Dec 2007 08:58:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
	[2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071209075807.GB29587@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org> <20071208100950.a3547868.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208100950.a3547868.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> It's a kmap_atomic() debugging patch which I wrote ages ago and whcih 
> Ingo sucked into his tree.  I don't _think_ this warning is present in 
> your tree at all.
> 
> http://lkml.org/lkml/2007/11/29/157 is where it starts.
> 
> I had a lenghty back-and-forth with Christoph on this within the past 
> couple of months and I cannot locate the thread and I don't recall 
> what the upshot was and Christoph is still offline.
> 
> Knocking out __GFP_ZERO at the point where the slab allocator(s) call 
> the page allocator seems like a good approach to me.
> 
> But I don't think we need to do anything for 2.6.24..

ok - Rafael, please strike this off the regressions list, there is no 
problem in .24 other than the double memset for some SLOB metadata.

	Ingo
