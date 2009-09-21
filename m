Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZIUFhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZIUFhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 01:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZIUFhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 01:37:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:47424 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbZIUFhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 01:37:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,422,1249282800"; 
   d="scan'208";a="189755485"
Subject: Re: [BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring
 buffer
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090918110953.GA9930@elte.hu>
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>
	 <20090918110953.GA9930@elte.hu>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 13:37:18 +0800
Message-Id: <1253511438.15717.705.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo,

I think it is a interesting idea to replace the original MCE logging
part implementation (MCE log ring buffer + /dev/mcelog misc device) with
tracing infrastructure. The tracing infrastructure has definitely more
features than original method, but it is more complex than original
method too.

The tracing infrastructure is good at tracing. But I think it may be too
complex to be used as a (hardware) error processing mechanism. I think
the error processing should be simple and relatively independent with
other part of the kernel to avoid triggering more (hardware) error
during error processing. What do you think about this?

Even if we will reach consensus at some point to re-write MCE logging
part totally. We still need to fix the bugs in original implementation
before the new implementation being ready. Do you agree?

Best Regards,
Huang Ying


