Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbYF0Uvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbYF0Uvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbYF0Uul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:50:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759986AbYF0Uuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:50:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [patch] make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
In-Reply-To: Oleg Nesterov's message of  Friday, 27 June 2008 20:33:33 +0400 <20080627163333.GB508@tv-sign.ru>
References: <cfd18e0f0806250749od875635r9e533d9f834bd8c4@mail.gmail.com>
	<20080625153806.GA499@tv-sign.ru>
	<cfd18e0f0806260809n4370c6eqc07c05ff93029658@mail.gmail.com>
	<cfd18e0f0806270106s5088327dja804c973bee117d@mail.gmail.com>
	<20080627163333.GB508@tv-sign.ru>
X-Windows: the art of incompetence.
Message-Id: <20080627204954.5970D154207@magilla.localdomain>
Date: Fri, 27 Jun 2008 13:27:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like I said, what makes most sense in the abstract is not what we're doing,
and what Solaris does may make more sense.  But I don't think it's worth
changing now.  Noone can be successfully relying on it, it's not standard, etc.


Thanks,
Roland
