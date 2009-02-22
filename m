Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZBVLnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZBVLnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 06:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZBVLnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 06:43:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbZBVLnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 06:43:14 -0500
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20090220172241.GF24538@elte.hu>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com>
	 <499EE162.4050008@oracle.com>  <20090220172241.GF24538@elte.hu>
Content-Type: text/plain
Date: Sun, 22 Feb 2009 12:43:00 +0100
Message-Id: <1235302980.4632.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 18:22 +0100, Ingo Molnar wrote:
> Eventually we should eliminate markers, their uses can either be 
> converted to new-style tracepoints, or to ftrace_printk().

I would like to never merge an ftrace_printk() user... just as I'd like
to get rid of every marker.

Then again, some people appear happy to commit their printk debug spree
too :/

