Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbYEFCaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbYEFCaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYEFC37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:29:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbYEFC36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:29:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] posix timers: fix sigqueue_free() vs __exit_signal() race
In-Reply-To: Oleg Nesterov's message of  Saturday, 3 May 2008 21:35:52 +0400 <20080503173552.GA8103@tv-sign.ru>
References: <20080503173552.GA8103@tv-sign.ru>
X-Zippy-Says: Vote for ME -- I'm well-tapered, half-cocked, ill-conceived and
    TAX-DEFERRED!
Message-Id: <20080506022922.7648426FA20@magilla.localdomain>
Date: Mon,  5 May 2008 19:29:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roland McGrath <roland@redhat.com>
