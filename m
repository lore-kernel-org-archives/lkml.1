Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbYFNGdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbYFNGdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 02:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYFNGdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 02:33:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52087 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYFNGdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 02:33:15 -0400
Date: Sat, 14 Jun 2008 08:33:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: fix "notrace" filtering priority
Message-ID: <20080614063302.GB24188@elte.hu>
References: <48536553.8020601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48536553.8020601@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Hi Steven,
> 
> This is a fix to give notrace filter rules priority over 
> "set_ftrace_filter" rules. This way functions set to be filtered and 
> also in the notrace list will not get traced.
> 
> This fix ensures that functions which are set to be filetered and are 
> concurrently marked as "notrace" don't get recorded. As of now, if a 
> record is marked as FTRACE_FL_FILTER and is enabled, then the notrace 
> flag is not checked. Tested on x86-32.

applied to tip/tracing/ftrace - thanks Abhishek.

	Ingo
