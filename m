Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbYF3SKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbYF3SKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYF3SKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:10:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbYF3SKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:10:15 -0400
Date: Mon, 30 Jun 2008 20:10:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: rostedt@goodmis.org, peterz@infradead.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 0/3] sched: newidle and RT wake-buddy fixes
Message-ID: <20080630181001.GE23739@elte.hu>
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
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> > -tip testing found this boot hang:
> 
> I may have found the issue: It looks like the hunk that initially 
> disables interrupts in load_balance_newidle() was inadvertently 
> applied to load_balance() instead during the merge to linux-tip.  If 
> you fold the following patch into my original patch, it should set 
> things right again.

ah, that might have indeed happened. Good catch, i'll test it tomorrow.

	Ingo
