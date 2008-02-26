Return-Path: <linux-kernel-owner+w=401wt.eu-S1761289AbYBZLcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289AbYBZLcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 06:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYBZLcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 06:32:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbYBZLcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 06:32:03 -0500
Date: Tue, 26 Feb 2008 12:31:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Bob Picco <bob.picco@hp.com>, Eric Whitney <eric.whitney@hp.com>
Subject: Re: 2.6.25-rc2-mm1 - boot hangs on ia64
Message-ID: <20080226113138.GC10996@elte.hu>
References: <1203955017.5046.29.camel@localhost> <20080226202308.FF40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226202308.FF40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Fujitsu machine can't boot too. my bisect indicate git-sched.patch 
> cause regression too.

hm, that's a bit weird - nothing really should have broken it. Could you 
try to do a specific bisection of sched-devel.git:

   http://people.redhat.com/mingo/sched-devel.git/README

it's just a handful of commits so it should be relatively quick to 
figure out. My only guess would be:

  Subject: sched: make early bootup sched_clock() use safer

but i think this has been ruled out before ...

	Ingo
