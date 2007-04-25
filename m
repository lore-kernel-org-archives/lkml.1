Return-Path: <linux-kernel-owner+w=401wt.eu-S1423224AbXDYGHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423224AbXDYGHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423228AbXDYGHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:07:16 -0400
Received: from holomorphy.com ([66.93.40.71]:54875 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423224AbXDYGHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:07:14 -0400
Date: Tue, 24 Apr 2007 23:05:31 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070425060531.GC19966@holomorphy.com>
References: <20070424212717.GR31925@holomorphy.com> <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 06:22:53PM -0700, Li, Tong N wrote:
> The goal of a proportional-share scheduling algorithm is to minimize the
> above metrics. If the lag function is bounded by a constant for any
> thread in any time interval, then the algorithm is considered to be
> fair. You may notice that the second metric is actually weaker than
> first. In fact, if an algorithm achieves a constant lag bound, it must
> also achieve a constant bound for the second metric, but the reverse is
> not necessarily true. But in some settings, people have focused on the
> second metric and still consider an algorithm to be fair as long as the
> second metric is bounded by a constant.

Using these metrics it is possible to write benchmarks quantifying
fairness as a performance metric, provided weights for nice numbers.

Not so coincidentally, this also entails a test of whether nice numbers
are working as intended.


-- wli

P.S. Divide by the length of the time interval to rephrase in terms of
CPU bandwidth.
