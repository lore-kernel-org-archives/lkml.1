Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbYARJYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbYARJYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYARJYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:24:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49118 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbYARJYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:24:07 -0500
Date: Fri, 18 Jan 2008 10:23:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: Reduce memory and intra-node effects with
	large count NR_CPUs fixup
Message-ID: <20080118092352.GH24337@elte.hu>
References: <20080117223546.419383000@sgi.com> <478FD9D9.7030009@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478FD9D9.7030009@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Hi Andrew,
> 
> My automatic scripts accidentally sent this mail prematurely.  Please 
> hold off applying yet.

I've picked it up for x86.git and i'll keep testing it (the patches seem 
straightforward) and will report any problems with the bite-head-off 
option unset.

[ The 32-bit NUMA compile issue is orthogonal to these patches - it's 
  due to the lack of 32-bit NUMA support in your changes :) That needs 
  fixing before this could go into v2.6.25. ]

	Ingo
