Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZDUPz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZDUPz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZDUPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:55:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43931 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZDUPzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:55:16 -0400
Date: Tue, 21 Apr 2009 17:50:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make
	workqueuetracepoints use TRACE_EVENT macro
Message-ID: <20090421155032.GB5402@redhat.com>
References: <20090420103612.4B4E.A69D9226@jp.fujitsu.com> <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin> <20090420104734.4B51.A69D9226@jp.fujitsu.com> <20090420084631.GA32625@elte.hu> <20090420222514.GA15680@redhat.com> <20090420234835.GC5997@nowhere> <20090421152843.GA5402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421152843.GA5402@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21, Oleg Nesterov wrote:
>
> On 04/21, Frederic Weisbecker wrote:
> >
> > For example,
> >
> > - the user opens the stat file
> > - then the entries are loaded and sorted into memory
> > - one of the workqueues is destroyed

Hmm. And what protects cws when, say, workqueue_stat_show() is called?
Can't we race with probe_workqueue_destruction()->kfree() ?

Oleg.

