Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbXL3Ojl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbXL3Ojl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbXL3Ojd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:39:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbXL3Ojc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:39:32 -0500
Date: Sun, 30 Dec 2007 15:39:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/lockdep.c:2658 check_flags()
Message-ID: <20071230143918.GO16946@elte.hu>
References: <20071229170554.GA21506@joi> <1198951387.31975.1.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198951387.31975.1.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > softirqs last disabled at (3521): [<ffffffff8020c97c>] 
> > call_softirq+0x1c/0x30
> 
> more early fixups for notify_die()..

thanks - i've picked this up into sched.git, for more testing.

	Ingo
