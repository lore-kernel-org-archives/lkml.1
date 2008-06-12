Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYFLQ4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYFLQ4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYFLQ4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:56:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:47206 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbYFLQ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:56:34 -0400
Subject: Re: Kernel marker has no performance impact on ia64.
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20080612164318.GB17814@redhat.com>
References: <48447052.3030300@redhat.com>
	 <1212445965.6269.22.camel@lappy.programming.kicks-ass.net>
	 <20080602232135.GA20173@Krystal>
	 <1212618449.19205.35.camel@lappy.programming.kicks-ass.net>
	 <20080604232241.GA8488@Krystal>
	 <1212653539.19205.47.camel@lappy.programming.kicks-ass.net>
	 <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins>
	 <20080612155332.GA16658@redhat.com> <48514BE3.3000506@redhat.com>
	 <20080612164318.GB17814@redhat.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 18:56:18 +0200
Message-Id: <1213289778.31518.132.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 12:43 -0400, Frank Ch. Eigler wrote:

> This is another reason why markers are a nice solution.  They allow
> passing of actual useful values: not just the %p pointers but the most
> interesting derived values (e.g., prev->pid). 

Useful to whoem? stap isn't the holy grail of tracing and certainly not
the only consumer of trace points, so restricting the information to
just what stap needs is actually making trace points less useful.

