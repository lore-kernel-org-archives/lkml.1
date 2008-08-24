Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYHXNjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYHXNjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 09:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYHXNjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 09:39:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYHXNjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 09:39:39 -0400
Date: Sun, 24 Aug 2008 15:39:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <glommer@redhat.com>
Cc: Glauber Costa <gcosta@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [GIT PULL] time.c - respin
Message-ID: <20080824133921.GA11330@elte.hu>
References: <200808201507.m7KF79Fk021224@int-mx1.corp.redhat.com> <20080821102222.GA31922@elte.hu> <20080821130737.GA28568@poweredge.glommer> <20080824123103.GA14688@elte.hu> <20080824131603.GA5447@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824131603.GA5447@elte.hu>
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


bisection is a bit inconclusive:

  ee096f75b69913dbad0e6f7f2572513de5c90002 is first bad commit

that is a merge commit.

here's the bisection log:

 # good: [887f98f6] Merge branch 'irq/sparseirq'
 # bad:  [e8d0f9bf] Merge branch 'x86/time'
 # good: [bea0a6a6] x86: wrap MCA_bus test around an ifdef
 # good: [8def7ec4] x86: reorganize 64-bit only code
 # bad:  [ee096f75] manual merge of x86/time
 # good: [291ae6a3] x86: make time_64 and time_32 equal
 # good: [a2496715] x86: merge time.c

	Ingo
