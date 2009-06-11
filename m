Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbZFKAvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbZFKAvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbZFKAvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:51:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:11641 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809AbZFKAvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:51:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,198,1243839600"; 
   d="scan'208";a="523454056"
Subject: Re: [PATCH 3/3] ring-buffer: add design document
From: Huang Ying <ying.huang@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20090610195525.429316815@goodmis.org>
References: <20090610195311.767699959@goodmis.org>
	 <20090610195525.429316815@goodmis.org>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 08:51:07 +0800
Message-Id: <1244681467.8361.654.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 03:53 +0800, Steven Rostedt wrote:
> +
> +cmpxchg - hardware assisted atomic transaction that performs the following:
> +
> +   A = B iff previous A == C
> +
> +   R = cmpxchg(A, C, B) is saying that we replace A with B if and only if
> +      current A is equal to C, and we put the old (current) A into R
> +
> +   R gets the previous A regardless if A is updated with B or not.
> +
> +   To see if the update was successful a compare of R == C may be used.

As far as I know, some architectures have no hardware assisted (NMI
safe) cmpxchg. Is it OK to use cmpxchg in architecture-independent code?

Best Regards,
Huang Ying


