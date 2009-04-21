Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbZDUWEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbZDUWEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbZDUWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:04:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:32955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583AbZDUWEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:04:12 -0400
Date: Tue, 21 Apr 2009 18:04:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tracing: recursion protection fixes
In-Reply-To: <20090420084729.GB32625@elte.hu>
Message-ID: <alpine.DEB.2.00.0904211803490.10097@gandalf.stny.rr.com>
References: <1240178868-18218-1-git-send-email-fweisbec@gmail.com> <20090420084729.GB32625@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Apr 2009, Ingo Molnar wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > Here are two fixes for tracing recursion protection.
> > The first slightly improves debugging in case of recursion detection.
> > The second fixes a spurious warning and tracing disabling while
> > activating a filter.
> > 
> > The following changes since commit 8e668b5b3455207e4540fc7ccab9ecf70142f288:
> >   Steven Rostedt (1):
> >         tracing: remove format attribute of inline function
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/recursion
> > 
> > Frederic Weisbecker (2):
> >       tracing/core: Add current context on tracing recursion warning
> >       tracing/ring-buffer: unlock recursion protection on discard
> > 
> >  kernel/trace/ring_buffer.c |   25 ++++++++++++++++++++-----
> >  1 files changed, 20 insertions(+), 5 deletions(-)
> 
> Pulled, thanks Frederic! Steve, any objections?

Ug, there was a whole block of email that I missed.

No objections here.

-- Steve

