Return-Path: <linux-kernel-owner+w=401wt.eu-S933238AbZKXPOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbZKXPOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933226AbZKXPOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:14:51 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:52096 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbZKXPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:14:50 -0500
Date: Tue, 24 Nov 2009 09:14:03 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Gleb Natapov <gleb@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, riel@redhat.com
Subject: Re: [PATCH v2 10/12] Maintain preemptability count even for
 !CONFIG_PREEMPT kernels
In-Reply-To: <20091124071250.GC2999@redhat.com>
Message-ID: <alpine.DEB.2.00.0911240906360.14045@router.home>
References: <1258985167-29178-1-git-send-email-gleb@redhat.com> <1258985167-29178-11-git-send-email-gleb@redhat.com> <1258990455.4531.594.camel@laptop> <20091123155851.GU2999@redhat.com> <alpine.DEB.2.00.0911231128190.785@router.home>
 <20091124071250.GC2999@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Gleb Natapov wrote:

> On Mon, Nov 23, 2009 at 11:30:02AM -0600, Christoph Lameter wrote:
> > This adds significant overhead for the !PREEMPT case adding lots of code
> > in critical paths all over the place.
> I want to measure it. Can you suggest benchmarks to try?

AIM9 (reaim9)?

Any test suite will do that tests OS performance.

Latency will also be negatively impacted. There are already significant
regressions in recent kernel releases so many of us who are sensitive
to these issues just stick with old kernels (2.6.22 f.e.) and hope
that the upstream issues are worked out at some point.

There is also lldiag package in my directory. See

http://www.kernel.org/pub/linux/kernel/people/christoph/lldiag

Try the latency test and the mcast test. Localhost multicast is typically
a good test for kernel performance.

There is also the page fault test that Kamezawa-san posted recently in the
thread where we tried to deal with the long term mmap_sem issues.
