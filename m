Return-Path: <linux-kernel-owner+w=401wt.eu-S1030917AbXDQW7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030917AbXDQW7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030919AbXDQW7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:59:00 -0400
Received: from holomorphy.com ([66.93.40.71]:46662 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030917AbXDQW67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:58:59 -0400
Date: Tue, 17 Apr 2007 15:59:02 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, Davide Libenzi <davidel@xmailserver.org>,
       Nick Piggin <npiggin@suse.de>, Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417225902.GQ2986@holomorphy.com>
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu> <20070417090538.GU8915@holomorphy.com> <20070417092422.GA19414@elte.hu> <20070417220809.GF11166@waste.org> <20070417223256.GP2986@holomorphy.com> <20070417223909.GO11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417223909.GO11115@waste.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 03:32:56PM -0700, William Lee Irwin III wrote:
>> I'm already working with this as my assumed nice semantics (actually
>> something with a specific exponential base, suggested in other emails)
>> until others start saying they want something different and agree.

On Tue, Apr 17, 2007 at 05:39:09PM -0500, Matt Mackall wrote:
> Good. This has a couple nice mathematical properties, including
> "bounded unfairness" which I mentioned earlier. What base are you
> looking at?

I'm working with the following suggestion:


On Tue, Apr 17, 2007 at 09:07:49AM -0400, James Bruce wrote:
> Nonlinear is a must IMO.  I would suggest X = exp(ln(10)/10) ~= 1.2589
> That value has the property that a nice=10 task gets 1/10th the cpu of a
> nice=0 task, and a nice=20 task gets 1/100 of nice=0.  I think that
> would be fairly easy to explain to admins and users so that they can
> know what to expect from nicing tasks.


I'm not likely to write the testcase until this upcoming weekend, though.


-- wli
