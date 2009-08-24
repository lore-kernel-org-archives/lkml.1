Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZHXXFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZHXXFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZHXXFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:05:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:12830 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbZHXXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZkvZYfcZZVGO6ygXVjOTdr5sgusJu2zGMIJDWlSD4/rAET0c2/p+1pF2w3LfJ4TSLP
         r+M9HCGN2DgBtWj+T5WFnBOGRIkWW8Yg8xfslnGufbkSqNqsxiknBrd+Tpd39yDqfupk
         /lYLge9UsOpZWgpue0ZTjBEcY5xrit64SdlVk=
Date: Tue, 25 Aug 2009 01:05:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v4 0/4] tracing: tweaks for generic syscall events
Message-ID: <20090824230509.GB5124@nowhere>
References: <1250917125-6174-1-git-send-email-jistone@redhat.com> <1251150194-1713-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251150194-1713-1-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 02:43:10PM -0700, Josh Stone wrote:
> This patch series moves the callbacks for the syscall tracepoints to the
> definition site, and adds generic TRACE_EVENTs which capture all syscall
> arguments.
> 
> New in v3:
> - Give the thread flag a more generic name: TIF_SYSCALL_TRACEPOINT.
> - Move the regfuncs to arch-specific files, per Jason's suggestion.
> - Change _WITH_CALLBACK to just _FN, per Ingo's suggestion.
> 
> New in v4:
> - Give the config flag a more generic name: HAVE_SYSCALL_TRACEPOINTS.
> - Undo the arch reorg of the regfuncs, but conditionalize on above.
> 
> 
> Sample trace output:
>         sendmail-974   [000] 55665.464492: sys_enter: NR 14 (1, 7fff60f3af40, 7fff60f3aec0, 8, 0, 7fb1b6a05161)
> 
>         sendmail-974   [000] 55665.464496: sys_exit: NR 14 = 0
> 
>         sendmail-974   [000] 55665.464507: sys_enter: NR 23 (5, 7fff60f3b0d0, 0, 0, 7fff60f3b150, 7fff60f3ef01)
> 
>             sshd-978   [000] 55667.845359: sys_exit: NR 23 = 1
> 
>             sshd-978   [000] 55667.845373: sys_enter: NR 14 (0, 7fffc645ce90, 7fffc645cf10, 8, 0, 101010101010101)
> 
>             sshd-978   [000] 55667.845381: sys_exit: NR 14 = 0
> 
>             sshd-978   [000] 55667.845383: sys_enter: NR 14 (2, 7fffc645cf10, 0, 8, 0, 101010101010101)
> 
>             sshd-978   [000] 55667.845386: sys_exit: NR 14 = 0
> 
>             sshd-978   [000] 55667.845395: sys_enter: NR 0 (3, 7fffc6458f80, 4000, 1, 0, 0)
> 
>             sshd-978   [000] 55667.845478: sys_exit: NR 0 = 48
> 
> 
> Signed-off-by: Josh Stone <jistone@redhat.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Jiaying Zhang <jiayingz@google.com>
> Cc: Martin Bligh <mbligh@google.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Paul Mundt <lethal@linux-sh.org>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


Thanks!

