Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYB2TQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYB2TQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYB2TQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:16:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYB2TQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:16:30 -0500
Date: Fri, 29 Feb 2008 20:15:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
Message-ID: <20080229191559.GA18339@elte.hu>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080227190519.GA14335@Krystal> <20080228163303.GA6195@redhat.com> <47C73121.2000109@qualcomm.com> <20080229090050.GA19519@elte.hu> <47C84DCD.5040803@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C84DCD.5040803@qualcomm.com>
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


* Max Krasnyanskiy <maxk@qualcomm.com> wrote:

> btw Being an RT guy you do not think that stop machine is evil ? [...]

i'm not "an RT guy", -rt is just one of the many projects i've been 
involved with.

and no, i dont think stop machine is "evil" - it's currently the best 
way to do certain things. If you can solve it better then sure, i'm 
awaiting your patches - but the only patch i saw from you so far was the 
one that turned off stop-machine for isolated cpus - which was 
incredibly broken and ignored the problem altogether.

Right now the answer is: "if you want to do hard RT then avoid doing 
things like loading modules". (which you should avoid while doing 
hard-RT anyway)

	Ingo
