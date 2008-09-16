Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYIPIZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYIPIZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYIPIZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:25:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35140 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYIPIZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:25:21 -0400
Date: Tue, 16 Sep 2008 10:24:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
Message-ID: <20080916082448.GA17287@elte.hu>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu> <20080915215053.GA11657@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915215053.GA11657@sgi.com>
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


* Dean Nelson <dcn@sgi.com> wrote:

> > while i understand the UV_BAU_MESSAGE case (TLB flushes are 
> > special), why does sgi-gru and sgi-xp need to go that deep? They are 
> > drivers, they should be able to make use of an ordinary irq just 
> > like the other 2000 drivers we have do.
> 
> The sgi-gru driver needs to be able to allocate a single irq/vector 
> pair for all CPUs even those that are not currently online. The sgi-xp 
> driver has similar but not as stringent needs.

why does it need to allocate a single irq/vector pair? Why is a regular 
interrupt not good?

	Ingo
