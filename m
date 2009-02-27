Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZB0H0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZB0H0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbZB0HZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:25:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbZB0HZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:25:50 -0500
Subject: Re: [PATCH] new irq tracer
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
In-Reply-To: <20090227123037.152E.A69D9226@jp.fujitsu.com>
References: <20090225165747.GC3123@redhat.com>
	 <20090225173412.GA14269@Krystal>
	 <20090227123037.152E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 08:25:32 +0100
Message-Id: <1235719532.4948.1265.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 12:33 +0900, KOSAKI Motohiro wrote:
> 
> I agree with IRQ latency tracing is very important.

Then use the irq-latency tracer, that thing is specifically created to
measure and locate irq-off latency sources.

We've been using it for years in the preempt-rt patch-set.

