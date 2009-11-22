Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZKVQvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZKVQvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZKVQvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:51:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:49655 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbZKVQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:51:00 -0500
Subject: Re: [PATCH 1/4] tracing: Use the perf recursion protection from
 trace event
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>
In-Reply-To: <20091122163714.GD5049@nowhere>
References: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
	 <1258887614.28730.353.camel@laptop>  <20091122163714.GD5049@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 17:50:45 +0100
Message-ID: <1258908645.28730.813.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 17:37 +0100, Frederic Weisbecker wrote:

> That's cleaner but adds an unnecessary overhead in the trace event
> path. We already disable the interrupts there. That's why I preferred
> to let the caller decide.

The trace path is already far from optimal, so I'd rather penalize that
than the regular swcounter path.



