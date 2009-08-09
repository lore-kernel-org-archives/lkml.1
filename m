Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbZHILAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbZHILAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZHILAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:00:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45076 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZHILAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:00:39 -0400
Date: Sun, 9 Aug 2009 13:00:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Add second diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090809110019.GA20236@elte.hu>
References: <20090806012645.GA24800@linux.vnet.ibm.com> <tip-86f044729ee3e4d8885c17371ce5a76f6f321dc7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-86f044729ee3e4d8885c17371ce5a76f6f321dc7@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Commit-ID:  86f044729ee3e4d8885c17371ce5a76f6f321dc7
> Gitweb:     http://git.kernel.org/tip/86f044729ee3e4d8885c17371ce5a76f6f321dc7
> Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> AuthorDate: Wed, 5 Aug 2009 18:26:45 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 9 Aug 2009 12:42:48 +0200
> 
> rcu: Add second diagnostic check for a possible CPU-hotplug race

has a build problem too:

 kernel/built-in.o: In function `rcu_cpu_notified':
 (.text+0x1d787): undefined reference to `cpu_notified'
 kernel/built-in.o: In function `rcu_init':
 (.init.text+0x1174): undefined reference to `cpu_notified'
 kernel/built-in.o: In function `rcu_init':
 (.init.text+0x11a8): undefined reference to `cpu_notified'

Maybe we should simplify all those Kconfig rules? It's a maze.

	Ingo
