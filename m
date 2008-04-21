Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYDUPGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYDUPGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbYDUPGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:06:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYDUPGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:06:30 -0400
Date: Mon, 21 Apr 2008 17:06:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Reuben Farrelly <reuben-linuxkernel@reub.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: StackProtector Oopses - Re: 2.6.25-mm1
Message-ID: <20080421150604.GH5474@elte.hu>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <48089BDE.6040100@reub.net> <20080418133645.GF31797@elte.hu> <4808B4EF.8030901@reub.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4808B4EF.8030901@reub.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0711]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:

>> hm, does it boot up fine with the attached patch and stackprotector 
>> enabled? It appears that your system got to the self-test so 
>> stackprotector is working mostly - it's just that the self-test went 
>> wrong.
>
> It boots up fine with that patch below and:
>
> tornado boot # grep STACKPROTECT /boot/config-2.6.25-mm1-wip
> CONFIG_CC_STACKPROTECTOR_ALL=y
> CONFIG_CC_STACKPROTECTOR=y
>
> In fact I'm running with it applied right now and it all seems good so 
> far, so I guess that's confirmation that it is just the test itself 
> which is problematic?

yeah. Arjan - any new patches to try that might fix the bootup test?

	Ingo
