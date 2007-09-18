Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbXIRUiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbXIRUiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbXIRUh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:37:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41106 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbXIRUh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:37:58 -0400
Date: Tue, 18 Sep 2007 22:17:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070918201708.GB1632@elte.hu>
References: <1190144798.5204.32.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190144798.5204.32.camel@earth>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> (2)
> 
> the 'p' (task_struct) parameter in the sched_class :: yield_task() is 
> redundant as the caller is always the 'current'. Get rid of it.
> 
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

ah - good one! I completely forgot about that parameter and it's indeed 
unneeded. Applied.

	Ingo
