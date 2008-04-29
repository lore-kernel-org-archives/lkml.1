Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYD2LgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYD2LgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYD2Lf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:35:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbYD2Lf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:35:56 -0400
Date: Tue, 29 Apr 2008 13:35:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: fix trimming e820 with MTRR holes.
Message-ID: <20080429113539.GA27617@elte.hu>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804281505.05764.yhlu.kernel@gmail.com> <200804290157.30651.yhlu.kernel@gmail.com> <200804290159.49882.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804290159.49882.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> @@ -760,7 +762,10 @@ void __init update_memory_range(u64 star
>  			continue;
>  		add_memory_region(final_start, final_end - final_start,
>  					 new_type);
> +		real_updated_size += find_end - final_start;

s/find_end/final_end

i hope it boots ;-)

	Ingo
