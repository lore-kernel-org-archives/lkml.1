Return-Path: <linux-kernel-owner+w=401wt.eu-S1764110AbZEADZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764110AbZEADZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 23:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZEADZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 23:25:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265AbZEADZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 23:25:13 -0400
Date: Thu, 30 Apr 2009 20:22:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] ring-buffer: add counters for commit overrun and
 nmi dropped entries
Message-Id: <20090430202242.aeeb1954.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0904302311320.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org>
	<20090501022400.894326175@goodmis.org>
	<20090430200034.fb794702.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0904302311320.20374@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 23:11:52 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> > hm.  Four functions in a row, all of which differ in but a single line.
> > 
> > unsigned long
> > ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
> > {
> > 	return some_common_function(buffer, cpu)->commit_overrun;
> > }
> > 
> > ?
> 
> But that actually takes thought. I like my cut and paste ;-)

Well, we all like your cut-n-paste, Steve.

Should you decide to retire the paste pot, and if you can bear to move
`struct ring_buffer' into a header, these four functions could be made
static inlines, with pleasant runtime results.

