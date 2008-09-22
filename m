Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYIVLGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYIVLGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYIVLGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:06:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYIVLGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:06:22 -0400
Date: Mon, 22 Sep 2008 13:05:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Dean Nelson <dcn@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH 1/3] switch vector_irq[] from irq number to irq_desc
	pointer v2
Message-ID: <20080922110542.GD5987@elte.hu>
References: <20080919200212.GA6528@sgi.com> <20080919200449.GB6528@sgi.com> <48D40A97.2000402@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D40A97.2000402@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0157]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Hi Ingo,
> 
> Note that my recent patch from a couple of weeks ago, stripped almost 
> all of the cpumask_t's from the io_apic functions.  Any chance we can 
> apply them before we add more?
> 
> I'd be willing to merge in Dean's patch over the top of mine (or 
> vice-versa).

i'm really looking forwards to Rusty's 'get-rid-of-cpumask_t use' 
patchset, which would solve such cpumask_t proliferation issues once and 
for all.

	Ingo
