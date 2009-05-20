Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZETJTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZETJTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbZETJTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:19:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876AbZETJTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:19:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
X-Fcc: ~/Mail/linus
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, fche@redhat.com
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
In-Reply-To: Peter Zijlstra's message of  Wednesday, 20 May 2009 09:38:47 +0200 <1242805127.26820.532.camel@twins>
References: <cover.1242763826.git.jbaron@redhat.com>
	<1242803524.26820.530.camel@twins>
	<20090520072750.DA9A0FC38D@magilla.sf.frob.com>
	<1242805127.26820.532.camel@twins>
Emacs: Our Lady of Perpetual Garbage Collection
Message-Id: <20090520091817.8E3EEFC38D@magilla.sf.frob.com>
Date: Wed, 20 May 2009 02:18:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But I think we should be asking GCC to get fixed. Since inline functions
> don't act like a compiler barrier anyway, they might as well not force
> argument evaluation either.

I quite agree.  I'm all for better compilation.  However, usual practice
in the kernel has been to complain about introducing C code sequences
that add a few instructions when compiled by compilers over 5 years old,
let alone the very latest one.  I think it was the expectation of that
sort of sensitive reaction to the hot-path impact of unused tracepoints
that motivated Jason's attempt at microoptimization.


Thanks,
Roland
