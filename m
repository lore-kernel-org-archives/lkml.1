Return-Path: <linux-kernel-owner+w=401wt.eu-S965680AbXDGJUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbXDGJUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965685AbXDGJUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:20:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44333 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965680AbXDGJUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:20:03 -0400
Date: Sat, 7 Apr 2007 11:19:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [sched] redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array
Message-ID: <20070407091955.GA16356@elte.hu>
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com> <20070404141546.GA862@elte.hu> <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> following the conversation on "a redundant reschedule call in 
> set_user_prio()", here is a possible approach.
> 
> The patch is somewhat intrusive as it even dares to adapt 
> TASK_PREEMPTS_CURR().

looks good to me, but the patch seems seriously whitespace-damaged: all 
tabs were converted to spaces.

	Ingo
