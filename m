Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbZAUL0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbZAUL0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZAUL0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:26:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34437 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbZAUL0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:26:04 -0500
Date: Wed, 21 Jan 2009 12:25:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, torvalds@linux-foundation.org,
       yinghai@kernel.org, venkatesh.pallipadi@intel.com,
       akpm@linux-foundation.org, arjan@infradead.org,
       linux-kernel@vger.kernel.org, jaswinderlinux@gmail.com,
       just.for.lkml@googlemail.com, npiggin@suse.de
Subject: Re: [patch] x86: fix page attribute corruption with cpa()
Message-ID: <20090121112530.GD23469@elte.hu>
References: <20090120222021.GB28352@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120222021.GB28352@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> This patch fixes a performance issue reported by Linus on his Nehalem 
> system. While Linus reverted the PAT patch (commit 
> 58dab916dfb57328d50deb0aa9b3fc92efa248ff) which exposed the issue, 
> existing cpa() code can potentially still cause wrong(page attribute 
> corruption) behavior.
> 
> This patch also fixes the "WARNING: at arch/x86/mm/pageattr.c:560" that 
> various people reported.

nice fix - applied to tip/x86/urgent, thanks Suresh!

	Ingo
