Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbXL2NRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbXL2NRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 08:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbXL2NRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 08:17:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48124 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbXL2NRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 08:17:32 -0500
Date: Sat, 29 Dec 2007 14:17:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: Top 9 kernel oopses/warnings for the week of December 29th,
	2007
Message-ID: <20071229131712.GB21805@elte.hu>
References: <477630CF.5070609@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477630CF.5070609@linux.intel.com>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> kerneloops.org news:
>
> * As of 2.6.24-rc6, oopses have a unique identifier which makes it 
>   possible to filter out duplicate reports of (and replies to) the 
>   same oops. Unfortunately some reporters remove this line from their 
>   reports to lkml.

i'd not mind printing out the bootup-ID as a regular part of the oops, 
as long as it's put into an unintrusive place, preferably without adding 
a new line. (just use an empty spot somewhere)

for example:

Call Trace: (ID afbf0104e2079481)
 [<ffffffff805079f6>] sysdev_driver_unregister+0x5b/0x91
 [<ffffffff806f2ef4>] cpufreq_register_driver+0x15a/0x19b
 [<ffffffff80cb0586>] powernowk8_init+0x86/0x94

	Ingo
