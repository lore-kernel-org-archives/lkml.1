Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbZCWRQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbZCWRQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbZCWRPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:15:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867AbZCWRPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:15:54 -0400
Date: Mon, 23 Mar 2009 18:14:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mszeredi@suse.cz, miklos@szeredi.hu, stable@kernel.org,
       tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched, ptrace: fix UML and ptrace slowness
Message-ID: <20090323171423.GA5185@elte.hu>
References: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu> <tip-84eef8ca758fa4a68c29f7d752376f6ca6872383@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-84eef8ca758fa4a68c29f7d752376f6ca6872383@git.kernel.org>
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


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> Commit-ID:  84eef8ca758fa4a68c29f7d752376f6ca6872383
> Gitweb:     http://git.kernel.org/tip/84eef8ca758fa4a68c29f7d752376f6ca6872383
> Author:     Miklos Szeredi <miklos@szeredi.hu>
> AuthorDate: Mon, 23 Mar 2009 16:07:24 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 23 Mar 2009 17:37:38 +0100
> 
> sched, ptrace: fix UML and ptrace slowness
> 
> This patch fixes bug #12208:
> 
>   Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12208
>   Subject         : uml is very slow on 2.6.28 host

Note, i zapped this commit as Linus took it in parallel so it's 
available upstream:

  53da1d9: fix ptrace slowness

	Ingo
