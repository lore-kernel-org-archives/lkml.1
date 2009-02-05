Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZBEMGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZBEMGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 07:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZBEMGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 07:06:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbZBEMGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 07:06:24 -0500
Date: Thu, 5 Feb 2009 13:06:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: tglx@linutronix.de, oleg@redhat.com, linux-kernel@vger.kernel.org,
       yanmin_zhang@linux.intel.com, seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
Message-ID: <20090205120608.GB8799@elte.hu>
References: <20090205112414.104100700@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205112414.104100700@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> This should hopefully address all the itimer borkage.

Applied to tip:timers/urgent, thanks Peter!

Yanmin: could you check hacbench_pth with latest tip/master, do
these fixes resolve that 3% regression you reported?

	Ingo
