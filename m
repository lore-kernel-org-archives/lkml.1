Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZDNAMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZDNAMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZDNAMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:12:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbZDNAMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:12:14 -0400
Date: Tue, 14 Apr 2009 02:11:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: mark get_parent_ip() notrace
Message-ID: <20090414001155.GO817@elte.hu>
References: <49D458B1.5000703@cn.fujitsu.com> <20090402122612.GB5965@nowhere> <49E2D8E3.4060708@cn.fujitsu.com> <1239633813.21121.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239633813.21121.27.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <srostedt@redhat.com> wrote:

> 
> On Mon, 2009-04-13 at 14:17 +0800, Lai Jiangshan wrote:
> > Frederic Weisbecker wrote:
> > > On Thu, Apr 02, 2009 at 02:18:25PM +0800, Lai Jiangshan wrote:
> > >> Impact: remove redundancy tracing log
> > >>
> > >> When tracer is "function" or "function_graph", too much
> > >> "get_parent_ip" are recorded in ring_buffer.
> > > 
> > > 
> > > Thanks, indeed this get_parent_ip was a bit harrassing
> > > in the traces, though I still don't understand why it is
> > > called so often.
> > > 
> > > Anyway, tracing it seems to me not useful.
> > > 
> > > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > 
> > > 
> > 
> > Hi, Ingo,
> > 	Could you apply this fix?
> > 
> > get_parent_ip() is a helper function for ftace, and it is called
> > by preempt_disable() and preempt_enable(), so it is occurred very
> > often.
> 
> I can pull it in too, if Ingo is busy.

I have put it into tip:sched/urgent - it belongs there file-wise. 
Will go upstream after -rc2 most likely.

	Ingo
