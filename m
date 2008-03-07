Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbYCGIru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbYCGIru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYCGIrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:47:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36534 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYCGIrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:47:41 -0500
Date: Fri, 7 Mar 2008 09:47:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce initial apicid
Message-ID: <20080307084725.GF12150@elte.hu>
References: <86802c440803061346u350d395djacf5e1aefffb0e4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803061346u350d395djacf5e1aefffb0e4b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> [PATCH] x86: introduce initial apicid
> 
> store initial_apicid from early identify. it is could be different 
> from phys_proc_id later
> 
> also print it out in proc

thanks, applied. This is a quirky area of x86 which is a frequent source 
of problems so i guess having more information in /proc/cpuinfo doesnt 
hurt ...

	Ingo
