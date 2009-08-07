Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZHGIL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZHGIL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757192AbZHGIL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:11:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53758 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbZHGILy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:11:54 -0400
Subject: Re: [RFC][PATCH 4/5] tracing/filters: Provide basic regex support
From: Peter Zijlstra <peterz@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1249618497.30024.36.camel@tropicana>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
	 <1249111408-8657-5-git-send-email-fweisbec@gmail.com>
	 <4A76782E.4030803@cn.fujitsu.com> <20090805224709.GH5025@nowhere>
	 <4A7A2E73.7030403@cn.fujitsu.com>  <20090806014941.GA24609@nowhere>
	 <1249618497.30024.36.camel@tropicana>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Aug 2009 10:11:33 +0200
Message-Id: <1249632693.32113.607.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 23:14 -0500, Tom Zanussi wrote:

> This a nice new feature - I considered doing it (not complete regexp
> support, just * in strings) for the original patch, but ran out of time
> - glad you added it.
> 
> I still think it makes sense to have some basic support for * in the
> regular filter file, so I'd vote for getting rid of the filter_regex
> file for now and just adding * support with the antislash escape to the
> regular filter file.  If you later wanted to add more full-fledged
> regexp support and it didn't make sense to do it in the regular filter
> file, then you could go crazy and add the filter_regex later...

I'll have to second this, /debug doesn't provide an ABI and having
multiple ways of expressing filters is just a pain.

I'm thinking of adding this filter capability to the perf tracepoints by
passing along a filter expression, having multiple ways of writing this
expression is just going to cause confusion.


