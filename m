Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbYFJJ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbYFJJ64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYFJJ6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:58:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbYFJJ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:58:46 -0400
Date: Tue, 10 Jun 2008 11:58:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ftrace: add debugfs entry 'failures'
Message-ID: <20080610095835.GH27706@elte.hu>
References: <4842CBB2.9040401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4842CBB2.9040401@gmail.com>
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


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Identify functions which had their mcount call-site updates failed. 
> This can help us track functions which ftrace shouldn't fiddle with, 
> and are thus not being traced. If there is no race with any external 
> agent which is modifying the mcount call-site, then this file displays 
> no entries (normal case).

applied to tip/tracing/ftrace, thanks.

	Ingo
