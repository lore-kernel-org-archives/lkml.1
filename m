Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbZC3E63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbZC3E63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 00:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZC3E6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 00:58:19 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48493 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZC3E6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 00:58:19 -0400
Date: Mon, 30 Mar 2009 10:28:13 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip 3/4 V3] tracing: kprobe-tracer plugin supports
	arguments
Message-ID: <20090330045813.GB6411@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <49CC08D2.30608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC08D2.30608@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 06:59:30PM -0400, Masami Hiramatsu wrote:

> +/* TODO: Move these functions to arch/XXX/include/asm/debugger.h */
> +

Maybe arch/xxx/lib/<>.c too?

I know its on your list of TODOs but I'd prefer to have an
arch_fetch_func_args() or somesuch in arch specific code, to start with.
It is trivial to implement the argument extraction code on certain
architectures and such a helper would be great.

Ananth
