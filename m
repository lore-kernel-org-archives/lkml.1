Return-Path: <linux-kernel-owner+w=401wt.eu-S936087AbZAPRT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936087AbZAPRT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760869AbZAPRSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:18:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50379 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760278AbZAPRSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:18:44 -0500
Date: Fri, 16 Jan 2009 18:18:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: linux-kernel@vger.kernel.org, hannes@cmpxchg.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH] softlockup: fix to allow compiling with
	!DETECT_HUNG_TASK
Message-ID: <20090116171832.GA18799@elte.hu>
References: <20090116170938.GA11346@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116170938.GA11346@google.com>
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


* Mandeep Singh Baines <msb@google.com> wrote:

> Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > doesnt build with !SOFTLOCKUP:
> > 
> > kernel/fork.c:1049: error: 'struct task_struct' has no member named 'last_switch_count'
> > kernel/fork.c:1050: error: 'struct task_struct' has no member named 'last_switch_timestamp'
> > 
> > Could you send a delta fix patch relative to -v4 please? Thanks,
> > 
> > 	Ingo
> 
> Oops. Will be more careful next time.

np - applied to tip/core/softlockup. Thanks,

	Ingo
