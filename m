Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYINOKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYINOKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYINOKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:10:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbYINOKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:10:32 -0400
Date: Sun, 14 Sep 2008 16:10:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: arjan@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/2] x86: Handle error returns in set_memory_*
Message-ID: <20080914141012.GA17727@elte.hu>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.970641000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080913000051.970641000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Correctly handle the error returns from set_memory_*. We have to free 
> memtype on error return path.

we should emit a kernel warning as well if any of those calls fail. 
Drivers should not be randomly poking on RAM ranges.

i'm also missing some background on this, could you please explain in a 
bit more detail about what errors there were triggered, and how they 
caused the display artifacts?

	Ingo
