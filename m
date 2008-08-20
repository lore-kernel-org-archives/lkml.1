Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYHTKl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYHTKl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYHTKlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:41:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYHTKlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:41:21 -0400
Date: Wed, 20 Aug 2008 12:41:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] xen: clarify locking used when pinning a pagetable.
Message-ID: <20080820104104.GE2816@elte.hu>
References: <48AB2DF3.1020207@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AB2DF3.1020207@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Add some comments explaining the locking and pinning algorithm when 
> using split pte locks.  Also implement a minor optimisation of not 
> pinning the PTE when not using split pte locks.

applied these commits to tip/x86/xen:

 7708ad6: xen: add xen_ prefixes to make tracing with ftrace easier
 11ad93e: xen: clarify locking used when pinning a pagetable.
 63d3a75: x86/paravirt: add spin_lock_flags lock op
 6e83358: xen: clean up domain mode predicates

Thanks,

	Ingo
