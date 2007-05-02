Return-Path: <linux-kernel-owner+w=401wt.eu-S1767181AbXEBSmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767181AbXEBSmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767188AbXEBSmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:42:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:57303 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767181AbXEBSmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:42:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,481,1170662400"; 
   d="scan'208";a="240832852"
Subject: Re: [patch] CFS scheduler, -v8
From: "Li, Tong N" <tong.n.li@intel.com>
To: tingy@cs.umass.edu
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <4637FE0A.7090405@cs.umass.edu>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 2 May 2007 11:42:20 -0700
Message-ID: <1178131340.25170.24.camel@tongli.jf.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 02 May 2007 18:42:21.0370 (UTC) FILETIME=[9E4159A0:01C78CE9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   Based on my understanding, adopting something like EEVDF in CFS should 
> not be very difficult given their similarities, although I do not have 
> any idea on how this impacts the load balancing for SMP. Does this worth 
> a try?
> 
>   Sorry for such a long email :-)

Thanks for the excellent explanation. I think EEVDF and many algs alike
assume global ordering of all tasks in the system (based on virtual
time), whereas CFS does so locally on each processor and relies on load
balancing to achieve fairness across processors. It'd achieve strong
fairness locally, but I'm not sure about its global fairness properties
in an MP environment. If ideally the total load weight on each processor
is always the same, then local fairness would imply global fairness, but
this is a bin packing problem and is intractable ...

  tong
