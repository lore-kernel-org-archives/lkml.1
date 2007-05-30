Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbXE3Cvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbXE3Cvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 22:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbXE3Cvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 22:51:33 -0400
Received: from holomorphy.com ([66.93.40.71]:42647 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbXE3Cvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 22:51:33 -0400
Date: Tue, 29 May 2007 19:51:32 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Li, Tong N" <tong.n.li@intel.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       tingy@cs.umass.edu, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de,
       pwil3058@bigpond.net.au, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070530025132.GB6909@holomorphy.com>
References: <20070523164859.GA6595@in.ibm.com> <20070523180316.GY19966@holomorphy.com> <20070525161424.GA5162@in.ibm.com> <1180113298.28264.24.camel@tongli.jf.intel.com> <20070528163919.GA28054@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528163919.GA28054@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 10:09:19PM +0530, Srivatsa Vaddagiri wrote:
> What do these task weights control? Timeslice primarily? If so, I am not
> sure how well it can co-exist with cfs then (unless you are planning to
> replace cfs with a equally good interactive/fair scheduler :)
> I would be very interested if this weight calculation can be used for
> smpnice based load balancing purposes too ..

Task weights represent shares of CPU bandwidth. If task i has weight w_i
then its share of CPU bandwidth is intended to be w_i/sum_i w_i.

"Load weight" seems to be used more in the scheduler source.


-- wli
