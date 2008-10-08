Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbYJHJZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbYJHJZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 05:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYJHJZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 05:25:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYJHJZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:25:30 -0400
Date: Wed, 8 Oct 2008 11:25:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: avoid dereferencing beyond stack + THREAD_SIZE
Message-ID: <20081008092509.GB22387@elte.hu>
References: <alpine.DEB.1.10.0810071413210.20896@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810071413210.20896@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0230]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> It's possible for get_wchan() to dereference past task->stack + 
> THREAD_SIZE while iterating through instruction pointers if fp equals 
> the upper boundary, causing a kernel panic.

applied to tip/x86/urgent, thanks David!

	Ingo
