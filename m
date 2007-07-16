Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXGPJST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXGPJST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXGPJSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:18:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54426 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbXGPJSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:18:10 -0400
Date: Mon, 16 Jul 2007 11:17:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070716091737.GB5964@elte.hu>
References: <20070706173319.GA2356@elte.hu> <200707141319.13270.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707141319.13270.edt@aei.ca>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ed Tomlinson <edt@aei.ca> wrote:

> I run a java application at nice 15.  Its been a background 
> application here for as long as SD and CFS have been around.  If I 
> have a compile running at nice 0, with v19 java gets so little cpu 
> that the the wrapper that runs to monitor it is timing out waiting for 
> it to start.  This is new in v19 - something in v19 is not meshing 
> well with my mix of applications...

how much longer did the startup of the java app get relative to say v18?

to debug this, could you check whether this problem goes away if you use 
nice 10 (or nice 5) instead of nice 15?

	Ingo
