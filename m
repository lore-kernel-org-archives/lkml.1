Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336Ab0ALSyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab0ALSyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157Ab0ALSym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:54:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0ALSym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:54:42 -0500
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	<20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
	<20100112045454.GJ5243@nowhere>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 12 Jan 2010 13:54:01 -0500
In-Reply-To: <20100112045454.GJ5243@nowhere> (Frederic Weisbecker's message of "Tue, 12 Jan 2010 05:54:56 +0100")
Message-ID: <y0mhbqr40ja.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Frederic Weisbecker <fweisbec@gmail.com> writes:

> [...]
> This is much more tricky in the case of uprobes as I see two
> ways to work with it:
> - probing on an already running process
> - probing on a process we are about to run
> [...]

As you might expect, in systemtap we've had to figure out this area
some time ago.  We use another utrace consumer called "task finder"
that registers interest in present / future processes, and gives us
kernel-space callbacks when these come and go.  You could merge it or
something like it.

- FChE
