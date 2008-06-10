Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbYFJJ57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbYFJJ57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYFJJ5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:57:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41862 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbYFJJ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:57:51 -0400
Date: Tue, 10 Jun 2008 11:57:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ftrace: prevent freeing of all failed updates
Message-ID: <20080610095740.GF27706@elte.hu>
References: <4842CB9A.1080800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4842CB9A.1080800@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Prevent freeing of records which cause problems and correspond to 
> function from core kernel text. A new flag, FTRACE_FL_CONVERTED is 
> used to mark a record as "converted". All other records are patched 
> lazily to NOPs. Failed records now also remain on frace_hash table. 
> Each invocation of ftrace_record_ip now checks whether the traced 
> function has ever been recorded (including past failures) and doesn't 
> re-record it again.

applied to tip/tracing/ftrace, thanks Abhishek.

	Ingo
