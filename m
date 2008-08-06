Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYHFPOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYHFPOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbYHFPON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:14:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbYHFPOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:14:11 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       dwilder@us.ibm.com, hch@infradead.org,
       Steven Rostedt <rostedt@goodmis.org>, mathieu.desnoyers@polymtl.ca
Subject: Re: [Patch 0/2] Renaming 'trace' to 'relay' and enhancements to 'relay'
References: <20080804040439.GA6415@in.ibm.com>
	<20080804152532.9367abff.akpm@linux-foundation.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 06 Aug 2008 11:08:10 -0400
In-Reply-To: <20080804152532.9367abff.akpm@linux-foundation.org> (Andrew Morton's message of "Mon, 4 Aug 2008 15:25:32 -0700")
Message-ID: <y0mmyjqji5h.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> [...]
>> 	Please find the patches that enhance the 'trace' infrastructure
>> (available in the -mm tree) and which introduce two new APIs
>> relay_dump() and relay_printk().
>> [...]

> I'm a bit perplexed by these trace patches
> (http://userweb.kernel.org/~akpm/mmotm/broken-out/trace-code [...]
> Is it useful?  Will it be useful?  [...]  I haven't heard much noise
> about it and I'm struggling to justify merging it.

Right.

> Also, it's starting to look somewhat similar to ftrace, which also
> provides sort of high-bandwidth per-cpu channels into userspace for
> tracing purposes.

Perhaps ftrace ought to use this facility for its debugfs-facing bulk
data interface rather than an internal one that cannot be used by
anyone else.  Perhaps lttng could use it.  Systemtap could.  I believe
a grand unification at this level was the idea.

- FChE
