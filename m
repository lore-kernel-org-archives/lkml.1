Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbZIIBj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbZIIBj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZIIBjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:39:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46980 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZIIBjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:39:25 -0400
Subject: Re: [PATCH 2/2] tracing/events: Add kexec tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <m1pra0hppp.fsf@fess.ebiederm.org>
References: <4AA70198.9070500@cn.fujitsu.com> <4AA701B3.704@cn.fujitsu.com>
	 <m1pra0hppp.fsf@fess.ebiederm.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 21:39:26 -0400
Message-Id: <1252460366.11070.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 18:27 -0700, Eric W. Biederman wrote:
> Li Zefan <lizf@cn.fujitsu.com> writes:
> 
> > When panic, save in ring buffer the time when crash happened,
> > the panic message, etc. And the data can be retrieved from
> > core dump file using flight-recorder, which is going to be a
> > module of the crash utility.
> >
> > Also if we implement flight-recorder in perf tool, those trace
> > outputs can be used by perf tool.
> 
> Please let's keep dynamic code out of crash_kexec if we can.

What dynamic code? It's a tracepoint not something like the function
tracer. It is activated via a bit test and a jmp. Not very dynamic.

-- Steve


> 
> If this is just about timestamsp I don't see the point.


