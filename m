Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbZASNeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbZASNeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZASNeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:34:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33555 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZASNeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:34:09 -0500
Date: Mon, 19 Jan 2009 14:33:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] ftrace interface for blktrace
Message-ID: <20090119133358.GE23299@elte.hu>
References: <20090116181611.GE6562@ghostprotocols.net> <20090117133737.GA8413@nowhere> <20090117202247.GK6562@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117202247.GK6562@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4588]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> I hope that by dropping the requirement to a userspace bit (be it big or 
> small) we can set a record for such kind of tracing infrastructure now 
> that tracepoints are being proposed left and right.
> 
> After all, somebody said that userspace is just a test case for the 
> kernel, and for things like developer assists...

Exactly.

Also, for certain tracing modes where we just do the run to gather 
statistics (but do not plan to capture any trace), it is more efficient to 
have an in-kernel histogram than to export gobs of data to user-space at 
great expense, just to throw away most of it there ;-)

	Ingo
