Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0CERUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:20:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:40057 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0CERUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:20:33 -0500
Subject: Re: [PATCH 2/2] perf: Walk through the relevant events only
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100305170331.GB5244@nowhere>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com>
	 <1267772426-5944-2-git-send-regression-fweisbec@gmail.com>
	 <1267781969.16716.55.camel@laptop>  <20100305170331.GB5244@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 18:20:29 +0100
Message-ID: <1267809629.4942.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 18:03 +0100, Frederic Weisbecker wrote:
> 
> Now isn't the problem more in the fact that most of the swevents
> should be tracepoints? 

No, different interface, and I don't want to require TRACE=y, I already
utterly hate that x86 requires PERF=y.

