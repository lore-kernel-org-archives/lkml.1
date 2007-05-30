Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039AbXE3AQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbXE3AQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXE3AQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:16:16 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:44818
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXE3AQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:16:15 -0400
Date: Tue, 29 May 2007 17:14:06 -0700
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Li, Tong N" <tong.n.li@intel.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       tingy@cs.umass.edu, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de,
       pwil3058@bigpond.net.au, kernel@kolivas.org,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070530001406.GA8449@gnuppy.monkey.org>
References: <20070523164859.GA6595@in.ibm.com> <20070523180316.GY19966@holomorphy.com> <20070525161424.GA5162@in.ibm.com> <1180113298.28264.24.camel@tongli.jf.intel.com> <20070528163919.GA28054@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528163919.GA28054@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 10:09:19PM +0530, Srivatsa Vaddagiri wrote:
> On Fri, May 25, 2007 at 10:14:58AM -0700, Li, Tong N wrote:
> > is represented by a weight of 10. Inside the group, let's say the two
> > tasks, P1 and P2, have weights 1 and 2. Then the system-wide weight for
> > P1 is 10/3 and the weight for P2 is 20/3. In essence, this flattens
> > weights into one level without changing the shares they represent.
> 
> What do these task weights control? Timeslice primarily? If so, I am not
> sure how well it can co-exist with cfs then (unless you are planning to
> replace cfs with a equally good interactive/fair scheduler :)

It's called SD. From Con Kolivas that got it right the first time around :)

> I would be very interested if this weight calculation can be used for
> smpnice based load balancing purposes too ..

bill

