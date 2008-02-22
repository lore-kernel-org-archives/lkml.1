Return-Path: <linux-kernel-owner+w=401wt.eu-S935097AbYBVNgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935097AbYBVNgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYBVNgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:36:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52192 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbYBVNgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:36:07 -0500
Date: Fri, 22 Feb 2008 14:35:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: gregory.haskins@gmail.com
Cc: Gregory Haskins <ghaskins@novell.com>, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 05/14] rearrange rt_spin_lock sleep
Message-ID: <20080222133541.GA8868@elte.hu>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net> <20080221152651.4804.4702.stgit@novell1.haskins.net> <47BECE30.8030100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BECE30.8030100@gmail.com>
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


* Gregory Haskins <gregory.haskins.ml@gmail.com> wrote:

> My assumption is that the xchg() (inside update_current()) acts as an 
> effective wmb().  If xchg() does not have this property, then this 
> code is broken and patch 6/14 should also add a:

xchg() is a strong implicit memory barrier, it implies smp_mb(). 
(historic sidenote: it was the very first SMP primitive we had in 
Linux.)

	Ingo
