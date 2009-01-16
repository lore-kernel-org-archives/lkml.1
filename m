Return-Path: <linux-kernel-owner+w=401wt.eu-S934497AbZAPNZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497AbZAPNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759665AbZAPNZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:25:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764166AbZAPNY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:24:59 -0500
Date: Fri, 16 Jan 2009 14:24:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: hannes@cmpxchg.org, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v4] softlockup: decouple hung tasks check from
	softlockup detection
Message-ID: <20090116132451.GA12546@elte.hu>
References: <20090114105426.GH2913@elte.hu> <20090115190840.GA1764@google.com> <20090116130621.GK5421@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116130621.GK5421@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4345]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > No problem. Rebased to tip/master.
> 
> applied to tip/core/softlockup - thanks Mandeep!

doesnt build with !SOFTLOCKUP:

kernel/fork.c:1049: error: 'struct task_struct' has no member named 'last_switch_count'
kernel/fork.c:1050: error: 'struct task_struct' has no member named 'last_switch_timestamp'

Could you send a delta fix patch relative to -v4 please? Thanks,

	Ingo
