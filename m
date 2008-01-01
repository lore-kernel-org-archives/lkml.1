Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYAAP4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYAAP4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYAAPrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:47:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567AbYAAPrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:47:52 -0500
Date: Tue, 1 Jan 2008 16:47:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier@gentoo.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, mingo@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/msr.h for sanitized headers: clean it or punt it
Message-ID: <20080101154730.GK4434@elte.hu>
References: <200712310045.24069.vapier@gentoo.org> <200712311310.32337.vapier@gentoo.org> <477931C8.4060208@zytor.com> <200712311349.28081.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712311349.28081.vapier@gentoo.org>
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


* Mike Frysinger <vapier@gentoo.org> wrote:

> Use __asm__ and __volatile__ in code that is exported to userspace.  
> Wrap kernel functions with __KERNEL__ so they get scrubbed.

thanks Mike, i have applied it to x86.git. (with a v2.6.24 merge target)

	Ingo
