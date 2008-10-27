Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYJ0Pg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYJ0Pg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYJ0PgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:36:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54585 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbYJ0PgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:36:19 -0400
Date: Mon, 27 Oct 2008 16:35:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/13 v2] ftrace: handle generic arch calls
Message-ID: <20081027153553.GL5704@elte.hu>
References: <20081022212721.167005680@goodmis.org> <20081022213551.196894190@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022213551.196894190@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The recordmcount script requires that the actual arch is passed in.
> This works well when ARCH=i386 or ARCH=x86_64 but does not handle the
> case of ARCH=x86.
> 
> This patch adds a parameter to the function to pass in the number of
> bits of the architecture. So that it can determine if x86 should be
> run for x86_64 or i386 archs.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

small sidenote: please preserve feedback/review activities in the 
changelog, even if there is no delta patch. I have added this to the 
changelog:

 v2: fix i386 bug, noticed by Andrew Morton

	Ingo
