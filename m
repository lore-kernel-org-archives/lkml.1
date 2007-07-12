Return-Path: <linux-kernel-owner+w=401wt.eu-S935550AbXGLAPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935550AbXGLAPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936458AbXGLAKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:10:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59911 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936123AbXGLAKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:10:34 -0400
Date: Thu, 12 Jul 2007 02:09:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       linux-rt-users@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -rt WIP] NMI-safe lightweight parallel-update -rt RCU
Message-ID: <20070712000937.GA1946@elte.hu>
References: <20070712000157.GA4168@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712000157.GA4168@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> Just work in progress, not recommended for inclusion.  Seems stable 
> under rigorous rcutorture testing, so should be OK for 
> experimentation.

nice stuff!

i'm wondering, could you try to do this as a splitup against -mm? I 
think we should get people exposed to the idea of RCU_PREEMPT in the 
upstream kernel a bit more. The netfilter folks promised some 
preparatory enhancements to make it easier, a few months ago :)

	Ingo
