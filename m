Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbYBIAIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbYBIAIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYBIAIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:08:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbYBIAIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:08:40 -0500
Date: Sat, 9 Feb 2008 01:08:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
Message-ID: <20080209000829.GA29986@elte.hu>
References: <20080209000456.GA21021@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209000456.GA21021@lixom.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Olof Johansson <olof@lixom.net> wrote:

> 2.6.22: 3332 ms
> 2.6.23: 4397 ms
> 2.6.24: 8953 ms
> 2.6.24-git19: 8986 ms

if you enable SCHED_DEBUG, and subtract 4 from the value of 
/proc/sys/kernel/sched_features, does it get any better?

if not, does writing 0 into /proc/sys/kernel/sched_features have any 
impact?

	Ingo
