Return-Path: <linux-kernel-owner+w=401wt.eu-S935543AbYBVJyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935543AbYBVJyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935300AbYBVJyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:54:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762672AbYBVJyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:54:09 -0500
Date: Fri, 22 Feb 2008 10:53:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Roland McGrath <roland@redhat.com>, ak@suse.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com
Subject: Re: [patch 1/2] x86, ptrace: support pebs in ds.c
Message-ID: <20080222095322.GD6269@elte.hu>
References: <20080213112349.A3283@sedona.ch.intel.com> <20080221210026.7B1C62701D5@magilla.localdomain> <029E5BE7F699594398CA44E3DDF554440169D67E@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF554440169D67E@swsmsx413.ger.corp.intel.com>
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> The ptrace API is the user interface for the debugging/BTS aspect of 
> it. As such, it will remain stable.

your last patch does this to arch/x86/kernel/ptrace.c:

  266 insertions(+), 174 deletions(-)

doesnt that change the ptrace bits and the ptrace API semantics?

	Ingo
