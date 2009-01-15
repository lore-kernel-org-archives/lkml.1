Return-Path: <linux-kernel-owner+w=401wt.eu-S1763188AbZAOK2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763188AbZAOK2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbZAOK2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:28:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49918 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294AbZAOK2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:28:06 -0500
Date: Thu, 15 Jan 2009 11:28:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing/ftrace: add missing unlock in
	register_stat_tracer()
Message-ID: <20090115102800.GB29296@elte.hu>
References: <alpine.DEB.1.10.0901142056470.22004@gandalf.stny.rr.com> <alpine.DEB.1.10.0901150524340.716@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901150524340.716@gandalf.stny.rr.com>
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
> Ingo, revert this patch (or don't pull it yet) I just noticed that it 
> does not compile. I should not be doing git pulls at night :-(

you just caught me in the middle of writing up a bugreport ;-)

kernel/trace/trace_stat.c:77: error: incompatible type for argument 1 of 'mutex_unlock'

easy enough to fix - and i did that.

	Ingo
