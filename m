Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbYH1Hu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbYH1Hu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYH1Hus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:50:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34826 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbYH1Hus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:50:48 -0400
Date: Thu, 28 Aug 2008 09:50:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: remove direct reference to mcount in trace code
Message-ID: <20080828075023.GI21875@elte.hu>
References: <alpine.DEB.1.10.0808272323030.1782@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808272323030.1782@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The mcount record method of ftrace scans objdump for references to 
> mcount. Using mcount as the reference to test if the calls to mcount 
> being replaced are indeed calls to mcount, this use of mcount was also 
> caught as a location to change. Using a variable that points to the 
> mcount address moves this reference into the data section that is not 
> scanned, and we do not use a false location to try and modify.
> 
> The warn on code was what was used to detect this bug.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

applied to tip/tracing/ftrace - thanks Steve!

	Ingo
