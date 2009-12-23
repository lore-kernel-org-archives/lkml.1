Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZLWT5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZLWT5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbZLWT5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:57:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbZLWT5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:57:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
X-Fcc: ~/Mail/utrace
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [PATCH 0/7] utrace/ptrace
In-Reply-To: Andi Kleen's message of  Wednesday, 23 December 2009 20:47:12 +0100 <20091223194712.GO20539@basil.fritz.box>
References: <20091218011116.GA29534@redhat.com>
	<20091222135809.1ab10869.akpm@linux-foundation.org>
	<20091223174232.GA14993@redhat.com>
	<20091223193313.1B89E16DB@magilla.sf.frob.com>
	<20091223194712.GO20539@basil.fritz.box>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20091223195532.8E65316DB@magilla.sf.frob.com>
Date: Wed, 23 Dec 2009 11:55:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have an estimate or better numbers how the overhead of 
> seccomp-over-utrace compares to the current in-tree seccomp?

I never measured it.  I would estimate that any difference one way or
another is in the noise.  The point of seccomp is to run a process that
almost never makes any system calls.  The only effects of utrace for that
use are on the system call path itself, and the essential effects there
(i.e. taking the tracing path vs the hot path) are the same as what the old
seccomp implementation does.

If you have some example uses of seccomp or something that can serve as a
benchmark for it, I would be glad to measure the difference.


Thanks,
Roland
