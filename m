Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0BJS0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:26:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab0BJS0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:26:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 2/4] x86, ptrace: regset extensions to support xstate
In-Reply-To: Oleg Nesterov's message of  Wednesday, 10 February 2010 16:43:33 +0100 <20100210154333.GB26654@redhat.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	<20100209202502.216592031@sbs-t61.sc.intel.com>
	<20100210112822.GB4546@redhat.com>
	<20100210154333.GB26654@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100210182610.B5D8ED489@magilla.sf.frob.com>
Date: Wed, 10 Feb 2010 10:26:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In fact, unless I missed something again, the 2nd and 3rd _copyout's could
> use pos as start_pos instead of offsetof(what_we_already_copied).

No, you should never do that.  start_pos and end_pos should be constants.


Thanks,
Roland
