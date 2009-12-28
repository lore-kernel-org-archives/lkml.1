Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbZL1KCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbZL1KCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZL1KCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:02:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:34159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZL1KCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:02:13 -0500
Subject: Re: [PATCH 2/2] perf lock: Fix output of tracing lock events
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <a6b9f31a0912260543g62785a58w6432f546c2fa6488@mail.gmail.com>
References: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1261041885.27920.110.camel@laptop>
	 <a6b9f31a0912260543g62785a58w6432f546c2fa6488@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 11:01:42 +0100
Message-ID: <1261994502.7135.51.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-26 at 22:43 +0900, Hitoshi Mitake wrote:

> > As to removing the waittime, I'm not sure, in this case, yes, but if you
> > want some other processing that hooks straight into the tracepoints
> > instead of using a logging structure, it might be useful.
> >
> > Removing that do_div() from there and exposing waittime as u64 in nsec,
> > for sure, that do_div() is just silly.
> >
> >
> >
> 
> I was too egoist. perf lock is not an only one user of lock events.
> 
> And I have a suggestion. Adding name of source files and lines of
> lock instances may be good thing for human's readability.
> How do you think?

file:line might be interesting indeed, but I worry about the size of the
event entry.. But lets see how that goes.

> > Why do we need to have instance resolution?

You forgot to answer this question.

Is it purely because the waittime computation as done by lockstat is not
good enough for you -- should we not fix that instead, that'd benefit
more people.

