Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZBIOUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZBIOUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZBIOUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:20:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34093 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbZBIOUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:20:42 -0500
Date: Mon, 9 Feb 2009 15:20:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ring_buffer: fix typing mistake
Message-ID: <20090209142030.GA28580@elte.hu>
References: <498FCB5A.5030207@cn.fujitsu.com> <alpine.DEB.1.10.0902090916340.14528@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902090916340.14528@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Mon, 9 Feb 2009, Lai Jiangshan wrote:
> 
> > 
> > Impact: Fix bug
> > 
> > I found several very very curious line.
> > It's so curious that it may be brought by typing mistake.
> > 
> > When (cpu_buffer->reader_page == cpu_buffer->commit_page):
> > 
> > 1) We haven't copied it for bpage is changed:
> >    bpage = cpu_buffer->reader_page->page;
> >    memcpy(bpage->data, cpu_buffer->reader_page->page->data + read ... )
> > 2) We need update cpu_buffer->reader_page->read, but
> >    "cpu_buffer->reader_page += read;" is not right.
> 
> Ouch! That is a bug.
> 
> Ingo, this is an urgent fix. Want me to pull it in and send it off to you?

Please do, yes.

	Ingo
