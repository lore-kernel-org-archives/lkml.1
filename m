Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYKWTeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYKWTeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYKWTe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:34:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbYKWTe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:34:27 -0500
Date: Sun, 23 Nov 2008 20:34:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/2] mmiotrace: fix buffer overrun detection
Message-ID: <20081123193413.GB2794@elte.hu>
References: <20081123154148.04e0851a@daedalus.pq.iki.fi> <alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com> <20081123212430.4f6700e9@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123212430.4f6700e9@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> From d5d72f3515ba3abffa317b985d7597718a024841 Mon Sep 17 00:00:00 2001
> From: Pekka Paalanen <pq@iki.fi>
> Date: Sun, 23 Nov 2008 19:18:18 +0200
> Subject: [PATCH] mmiotrace: fix buffer overrun detection
> 
> When ftrace framework moved to use the ring buffer facility, the buffer
> overrun detection was broken after 2.6.27 by commit
> 
> commit 3928a8a2d98081d1bc3c0a84a2d70e29b90ecf1c
> Author: Steven Rostedt <rostedt@goodmis.org>
> Date:   Mon Sep 29 23:02:41 2008 -0400
> 
>     ftrace: make work with new ring buffer
> 
>     This patch ports ftrace over to the new ring buffer.
> 
> The detection is now fixed by using the ring buffer API.
> 
> When mmiotrace detects a buffer overrun, it will report the number of
> lost events. People reading an mmiotrace log must know if something was
> missed, otherwise the data may not make sense.
> 
> Signed-off-by: Pekka Paalanen <pq@iki.fi>
> ---
> 
> Ingo, could these two patches still make it into .28?

Sure - applied them to tip/tracing/urgent:

  fb91ee6: tracing, doc: update mmiotrace documentation
  7ee1768: x86, mmiotrace: fix buffer overrun detection

Does this make mmiotrace fully functional in .28 ?

	Ingo
