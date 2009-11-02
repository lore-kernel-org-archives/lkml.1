Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZKBO7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZKBO7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZKBO7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:59:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34131 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbZKBO7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:59:44 -0500
Date: Mon, 2 Nov 2009 15:59:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/6] x86: cleanups and fixes for irq migration code
	during cpu offline
Message-ID: <20091102145938.GD23776@elte.hu>
References: <20091026222430.313656103@sbs-t61.sc.intel.com> <1256930729.2679.10.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256930729.2679.10.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Mon, 2009-10-26 at 15:24 -0700, Siddha, Suresh B wrote:
> > First four patches in the series unify the fixup_irqs() along with
> > couple of cleanups. It also fixes an issue where the interrupt subsystem can 
> > point the interrupt to the offlined cpu (for non interrupt-remapping case)
> > causing the device to not work. This was observed by Gary.
> > 
> > These four patches are ready for inclusion
> 
> Ingo, if no one has any objections, can you please consider the first 
> four patches in this patchset for -tip testing?

Yep, queued them up. I went for the whole batch as it looks good and 
needs wider testing as well.

Note, i fixed a few small details in patch #5.

Note #2, the signoffs from Gary looked weird - they were put last while 
the patches did not come from him. I changed those to Acked-by - i 
suppose that was the intention, right?

	Ingo
