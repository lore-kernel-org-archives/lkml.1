Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYGCOlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYGCOlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYGCOlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:41:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56341 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYGCOlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:41:39 -0400
Date: Thu, 3 Jul 2008 16:41:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: rostedt@goodmis.org, peterz@infradead.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 0/3] sched: newidle and RT wake-buddy fixes
Message-ID: <20080703144124.GA653@elte.hu>
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com> <20080630131511.GA7506@elte.hu> <4868DCC7.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4868DCC7.BA47.005A.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> I may have found the issue: It looks like the hunk that initially 
> disables interrupts in load_balance_newidle() was inadvertently 
> applied to load_balance() instead during the merge to linux-tip.  If 
> you fold the following patch into my original patch, it should set 
> things right again.

ah, sorry - indeed! I've reactivated your patch and i'm testing it now.

	Ingo
