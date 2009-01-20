Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZATISA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZATISA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZATIRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:17:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZATIRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:17:50 -0500
Date: Tue, 20 Jan 2009 09:16:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Justin Madru <jdm64@gawab.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
Message-ID: <20090120081650.GA29725@elte.hu>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.C4F.Q9QdJB@chimera> <49756F3E.6050304@gawab.com> <20090120074312.GD16426@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120074312.GD16426@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> (added Cc:s)

> Justin, does it work if you apply the patch below instead of the revert?

hm, that patch wont build because the protect_asmlinkage macro is rather 
limited - it cannot deal with structure parameters.

We might be better off with a revert here, and a comment added that points 
out the problem.

	Ingo
