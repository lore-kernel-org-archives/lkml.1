Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYEFMGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYEFMGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYEFMGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:06:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbYEFMGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:06:30 -0400
Date: Tue, 6 May 2008 14:06:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       David Bahi <dbahi@novell.com>
Subject: Re: [PATCH] sched: fix SCHED_OTHER balance iterator to include all
	tasks
Message-ID: <20080506120616.GI32591@elte.hu>
References: <20080505142739.24888.31658.stgit@lsg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505142739.24888.31658.stgit@lsg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Ingo,
>  The follow patch applies to sched-devel.  I know the original 
>  function was somehow trying to protect against dequeueing by 
>  pre-iterating.  I am not sure if I captured the intent properly in 
>  that regard.  What I can say is that the old algorithm would miss 
>  tasks, and that is now fixed.  It may need further adjustment if I 
>  missed the pre-iterating operation.
> 
> Hi Peter,
>  I was wrong earlier when I mentioned there might be a problem with 
>  entity_is_task().  I think this was the root cause of what I was 
>  seeing. Sorry for the red-herring.

applied Gregory, thanks. Nice fix! Peter, do you concur with Gregory's 
analysis?

	Ingo
