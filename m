Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYHUJLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYHUJLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 05:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYHUJLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 05:11:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbYHUJLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 05:11:11 -0400
Date: Thu, 21 Aug 2008 11:10:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: export pv_lock_ops non-GPL
Message-ID: <20080821091051.GA1683@elte.hu>
References: <48AC62EB.6060804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AC62EB.6060804@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> None of the spinlock API is exported GPL, so there's no reason for 
> pv_lock_ops to be.

uhm, why is this even a question? All of this stuff is so deep inside 
the guts of the kernel ... so nope - if then we want to change the 
others to _GPL exports as well, just to make sure nobody gets funny 
ideas.

	Ingo
