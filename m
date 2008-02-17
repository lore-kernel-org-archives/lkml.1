Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYBQQdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYBQQdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYBQQdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:33:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49344 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYBQQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:33:04 -0500
Date: Sun, 17 Feb 2008 17:32:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] sched: fix signedness warnings in sched.c
Message-ID: <20080217163252.GH6006@elte.hu>
References: <1203098196.15275.7.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203098196.15275.7.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Unsigned long values are always assigned to switch_count,
> make it unsigned long.
> 
> kernel/sched.c:3897:15: warning: incorrect type in assignment (different signedness)
> kernel/sched.c:3897:15:    expected long *switch_count
> kernel/sched.c:3897:15:    got unsigned long *<noident>
> kernel/sched.c:3921:16: warning: incorrect type in assignment (different signedness)
> kernel/sched.c:3921:16:    expected long *switch_count
> kernel/sched.c:3921:16:    got unsigned long *<noident>

thanks, applied.

	Ingo
