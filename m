Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbYFJJ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbYFJJ7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYFJJ7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:59:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45143 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYFJJ7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:59:22 -0400
Date: Tue, 10 Jun 2008 11:59:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ftrace: prevent freeing of all failed updates
Message-ID: <20080610095907.GI27706@elte.hu>
References: <4842CB9A.1080800@gmail.com> <Pine.LNX.4.58.0806021401340.10366@gandalf.stny.rr.com> <4844B48D.5020509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4844B48D.5020509@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Steven Rostedt wrote:
> > If we unload a module and reload it, will it ever get converted again?
> 
> The intent was always to filter core kernel functions to prevent their 
> freeing. Here's a fix which should allow re-recording of module 
> call-sites.

applied to tip/tracing/ftrace, thanks.

	Ingo
