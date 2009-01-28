Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZA1AoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZA1AoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZA1AoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:44:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44964 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZA1AoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:44:14 -0500
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Neil Horman <nhorman@tuxdriver.com>, utrace-devel@redhat.com
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 27 Jan 2009 19:43:32 -0500
In-Reply-To: <20090127224303.GB5850@nowhere> (Frederic Weisbecker's message of "Tue, 27 Jan 2009 23:43:05 +0100")
Message-ID: <y0mtz7ks1jf.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> [...]
> Speaking about a global syscall tracer, I made a patch to trace only the syscalls
> with the function-graph-tracer.
> http://lkml.org/lkml/2008/12/30/267 This low-level part can easily
> be used by all tracers that would like to inspect syscalls.
> [...]
> Just a change is needed: Steven requested that the part inside
> syscall_trace_enter become a tracepoint, making it totally shareable
> between tracers and easy to turn on and off.

Alternately, you could just rely on utrace's hooks.  They were thought
out more fully with respect to parameter access, manipulation, and
programmatic control befitting even a debugger.


- FChE
