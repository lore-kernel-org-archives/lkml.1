Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZIOKTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZIOKTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZIOKTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:19:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZIOKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:19:50 -0400
Subject: Re: [PATCH 0/2] tracing: Tracing integration - dynamic ftrace for
 SystemTap
From: Peter Zijlstra <peterz@infradead.org>
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>, paulus@samba.org,
       systemtap@sources.redhat.com
In-Reply-To: <1253009731.5506.39.camel@laptop>
References: <4AAF6724.9080201@bk.jp.nec.com>
	 <1253009731.5506.39.camel@laptop>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 12:19:33 +0200
Message-Id: <1253009974.5506.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 12:15 +0200, Peter Zijlstra wrote:
> On Tue, 2009-09-15 at 19:06 +0900, Atsushi Tsuji wrote:
> > The patches doesn't contain the performance counters integration,
> > since it is still in development. I think following implementations are
> > needed:
> > - add new type to perf_id (like PERF_TYPE_FTRACE)
> > - add event ids to struct dyn_ftrace
> > - add interfaces to reference event ids by user (via debugfs?)
> > - add probe function to count ftrace events (call do_perf_swcounter_event)
> 
> That's long since been done,.. 

Or are you talking about the mcount thing? Simply expose the mcount hook
as a regular tracepoint and perf can already use it.

