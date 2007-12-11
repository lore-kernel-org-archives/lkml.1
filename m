Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbXLKG2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbXLKG2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 01:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXLKG2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 01:28:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbXLKG2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 01:28:38 -0500
Date: Tue, 11 Dec 2007 01:27:20 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
	[2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071211062720.GA29764@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Lameter <clameter@sgi.com>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org> <20071208100950.a3547868.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org> <20071208195211.GA3727@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208195211.GA3727@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 08:52:11PM +0100, Ingo Molnar wrote:

 > so even today's upstream kernel, which has 'ancient' SLUB code, SLAB and 
 > SLUB have essentially the same linecount:
 > 
 >   $ wc -l mm/slab.c mm/slub.c
 >   4478 mm/slab.c
 >   4125 mm/slub.c
 > 
 > (and while linecount != complexity, there is a strong relationship.)
 > 
 > With SLAB having 10 years more test coverage and tuning.

FWIW, the one thing slub does that slab doesn't that I find really nice
is being enable to enable debugging at boot time rather than compile time.

We don't get many people running benchmarks against the Fedora kernel,
so any scalability differences between slub/slab probably won't reach us
until we start shipping betas of the next RHEL based on the same kernel.

Which leaves my only other gripe.  It broke slabtop.
There's an alternative implementation in Documentation/vm/slabinfo.c
(why there not say, util-linux, home of current slabtop?) 

	Dave

-- 
http://www.codemonkey.org.uk
