Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZLWTeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZLWTeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZLWTeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:34:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbZLWTeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:34:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/utrace
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [PATCH 0/7] utrace/ptrace
In-Reply-To: Oleg Nesterov's message of  Wednesday, 23 December 2009 18:42:32 +0100 <20091223174232.GA14993@redhat.com>
References: <20091218011116.GA29534@redhat.com>
	<20091222135809.1ab10869.akpm@linux-foundation.org>
	<20091223174232.GA14993@redhat.com>
Emacs: because one operating system isn't enough.
Message-Id: <20091223193313.1B89E16DB@magilla.sf.frob.com>
Date: Wed, 23 Dec 2009 11:33:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well. I had a lot of technical discussions with Roland about utrace,
> but I never asked him why he created this thing ;) To me, utrace
> looks like vfs. Currently we have the single and very poor "filesystem",
> ptrace. Until we add the appropriate layer, we can't expect the
> further improvements is this area.

I think that is an excellent analogy, and it's one I've used before.

Oleg and I have had our hands pretty full just with the infrastructure
layer and with ptrace.  Having this layer in the kernel is what makes
it tractable for a lot of other people to collaborate on new features
in this space, and that's what we want to enable and accelerate.  
Some of those on the CC list have worked and are working on such
things, and I hope they will pipe up about those.

Given the date, I suspect we might not see much from anybody on this
(or anything) until January.  Myself, I expect to be largely offline
for the rest of the year.

As Oleg mentioned, I have a cleanup/reimplementation of seccomp using
utrace.  That is quite a trivial use--it demonstrates how easy the
utrace API makes it to do things like that, in contrast to previous
solutions with arch-specific assembly hacking and so forth.  I can
dust that patch off and post it if anybody cares.

Some other features based on utrace have been floating around for some
time, posted here before.  Those include uprobes, kmview, and the gdb
stub.  I don't which of those are quite ready for merging, but honing
and polishing them gets quite a lot more doable with utrace in the
tree instead of out.


Thanks,
Roland
