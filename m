Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbZHXLCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbZHXLCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZHXLCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:02:51 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51210 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZHXLCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:02:50 -0400
Date: Mon, 24 Aug 2009 20:02:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Josh Stone <jistone@redhat.com>,
       linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090824110251.GA18420@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
	Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Jiaying Zhang <jiayingz@google.com>,
	Martin Bligh <mbligh@google.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org> <20090824084101.GE2424@elte.hu> <20090824085944.GA15330@linux-sh.org> <20090824095652.GC25267@elte.hu> <20090824110123.GA6162@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824110123.GA6162@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 01:01:23PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > ( Also, could you please fix your mailer so that it does not damage 
> >   threads? It generates such bogus headers:
> > 
> >     Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
> >         Ingo Molnar <mingo@elte.hu>,
> >         Frederic Weisbecker <fweisbec@gmail.com>,
> >         Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
> >         Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
> >        	Steven Rostedt <rostedt@goodmis.org>,
> >         Peter Zijlstra <peterz@infradead.org>,
> >         Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
> >         Jiaying Zhang <jiayingz@google.com>,
> >         Martin Bligh <mbligh@google.com>,
> >         Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> >   which messes up replies. )
> 
> Paul, you forgot to reply to this bit. Mail-Followup-To is quite a 
> PITA on lkml.
> 
Yes, this is the first I realized it was doing this, I'll look in to it,
thanks.
