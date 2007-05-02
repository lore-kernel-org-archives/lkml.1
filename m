Return-Path: <linux-kernel-owner+w=401wt.eu-S2993124AbXEBTKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993124AbXEBTKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993130AbXEBTKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:10:11 -0400
Received: from holomorphy.com ([66.93.40.71]:37886 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993124AbXEBTKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:10:03 -0400
Date: Wed, 2 May 2007 12:10:33 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: tingy@cs.umass.edu, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502191033.GV31925@holomorphy.com>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <1178131340.25170.24.camel@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178131340.25170.24.camel@tongli.jf.intel.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At some point in the past, Ting Yang wrote:
>>   Based on my understanding, adopting something like EEVDF in CFS should 
>> not be very difficult given their similarities, although I do not have 
>> any idea on how this impacts the load balancing for SMP. Does this worth 
>> a try?
>>   Sorry for such a long email :-)

On Wed, May 02, 2007 at 11:42:20AM -0700, Li, Tong N wrote:
> Thanks for the excellent explanation. I think EEVDF and many algs alike
> assume global ordering of all tasks in the system (based on virtual
> time), whereas CFS does so locally on each processor and relies on load
> balancing to achieve fairness across processors. It'd achieve strong
> fairness locally, but I'm not sure about its global fairness properties
> in an MP environment. If ideally the total load weight on each processor
> is always the same, then local fairness would imply global fairness, but
> this is a bin packing problem and is intractable ...

It's sort of obvious how to approximate it, but not entirely obvious
whether a given approximation actually suffices. More help with the
theoretical aspects is needed.


- wli
