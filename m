Return-Path: <linux-kernel-owner+w=401wt.eu-S1751170AbZHXBk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbZHXBk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZHXBk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:40:28 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44385 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZHXBk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:40:27 -0400
Date: Mon, 24 Aug 2009 10:40:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090824014025.GA12653@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
	Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Jiaying Zhang <jiayingz@google.com>,
	Martin Bligh <mbligh@google.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090823211422.GG6256@nowhere>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 11:14:24PM +0200, Frederic Weisbecker wrote:
> On Fri, Aug 21, 2009 at 09:58:43PM -0700, Josh Stone wrote:
> > The bodies of syscall_regfunc and syscall_unregfunc need the
> > arch-specific flag TIF_SYSCALL_TRACEPOINT, which only exists
> > on x86 and s390, so they should live in arch-specific files.
> 
> Sh also does, but currently in a seperate development branch.
> (Adding Paul Mundt in Cc to prevent from further linux-next breakage).
> 
Thanks, I'll take care of this as well as the other ftrace syscalls
breakage during the merge window. At the moment I don't have any good
ideas on how to fix the workflow issues, and -tip likewise doesn't care
about -next impact, so there's somewhat of an impasse.
