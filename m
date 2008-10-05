Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYJEJuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYJEJuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 05:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYJEJuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 05:50:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58163 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbYJEJuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 05:50:03 -0400
Date: Sun, 5 Oct 2008 11:49:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] Return an error when setting a nonexistent tracer
Message-ID: <20081005094959.GB29909@elte.hu>
References: <48E7CC5C.7080306@gmail.com> <alpine.DEB.1.10.0810041959160.11586@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810041959160.11586@gandalf.stny.rr.com>
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

> On Sat, 4 Oct 2008, Frederic Weisbecker wrote:
> 
> > When one try to set a nonexistent tracer, no error is returned
> > as if the name of the tracer was correct.
> > We should return -EINVAL.
> 
> Thanks! This has been something I've been meaning to do for a long
> time but have never got around to doing it.
> 
> ( I knew if I waited long enough, someone else would do it ;-)
> 
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

applied to tip/tracing/core, thanks!

	Ingo
