Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbYCEIuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbYCEIuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbYCEIun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:50:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139AbYCEIum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:50:42 -0500
Date: Wed, 5 Mar 2008 09:50:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Jackson <pj@sgi.com>, Max Krasnyanskiy <maxk@qualcomm.com>,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-ID: <20080305085019.GA24097@elte.hu>
References: <1204545445.11412.6.camel@twins> <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy> <20080303121033.c8c9651c.pj@sgi.com> <1204568316.8514.18.camel@twins> <20080304013534.4e51ae48.pj@sgi.com> <1204628762.6241.46.camel@lappy> <47CDA885.3000103@qualcomm.com> <20080304191159.a02be58b.pj@sgi.com> <1204706272.6241.79.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204706272.6241.79.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> So by providing a .config option for strict backward compatibility, a 
> simple way for runtime compatibility (moving all IRQs to the root) 
> which should be easy to do if the kernel upgrade is accompanied by a 
> (limited) user-space upgrade.

/me likes

this looks like the most straightforward and most manageable approach 
proposed so far - i always thought that cpusets should boot up with some 
meaningful default set that people could play with. This would really 
push cpusets into mainstream use i believe.

Any patch i could try out, to see how well this works in practice? ;-)

	Ingo
