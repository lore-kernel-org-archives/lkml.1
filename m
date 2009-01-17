Return-Path: <linux-kernel-owner+w=401wt.eu-S1765426AbZAQTJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765426AbZAQTJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 14:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbZAQTJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 14:09:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43676 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbZAQTJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 14:09:33 -0500
Date: Sat, 17 Jan 2009 20:09:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] ftrace interface for blktrace
Message-ID: <20090117190913.GA17722@elte.hu>
References: <20090116181611.GE6562@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116181611.GE6562@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Hi Jens,
> 
> 	The patch below adds a ftrace interface for blktrace, allowing 
> people to use it without any required userspace tools, using sysfs to 
> setup the act_mask, pid, start_lba, end_lba.

Very nice patch!

Jens, i'm wondering what's your take on this direction is. I think the 
consolidation effect is great and the built-in IO tracing capabilities are 
very nice.

We can still get the raw events too and do user-space post-processing, 
when that is desired - so this does not limit anything that blktrace was 
able to do before - it only extends on it.

Is there any particular blktrace feature you can think of that is not 
present in the blktrace ftrace plugin?

	Ingo
