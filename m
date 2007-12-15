Return-Path: <linux-kernel-owner+w=401wt.eu-S1765600AbXLOHaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765600AbXLOHaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXLOHaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:30:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41180 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbXLOHaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:30:00 -0500
Date: Sat, 15 Dec 2007 08:29:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [patch 1/5] x86, ptrace: remove bad comment
Message-ID: <20071215072937.GB12110@elte.hu>
References: <20071214174858.A20475@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214174858.A20475@sedona.ch.intel.com>
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

Markus,

i've applied the first 4 patches to x86.git.

another detail: shouldnt this be structured so that the APIs are 
introduced in kernel/ptrace.c, and that the architecture offers the 
mechanism. (which would thus be ptrace-independent) This would also open 
these APIs up to kernel-internal use and to be used by other 
architectures.

	Ingo
