Return-Path: <linux-kernel-owner+w=401wt.eu-S1764383AbYB0HLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764383AbYB0HLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbYB0HLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:11:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbYB0HLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:11:45 -0500
Date: Wed, 27 Feb 2008 08:11:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Bob Picco <bob.picco@hp.com>, Eric Whitney <eric.whitney@hp.com>
Subject: Re: 2.6.25-rc2-mm1 - boot hangs on ia64
Message-ID: <20080227071118.GA4638@elte.hu>
References: <20080226202308.FF40.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080226113138.GC10996@elte.hu> <20080227103831.423F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227103831.423F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
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

> > hm, that's a bit weird - nothing really should have broken it. Could you 
> > try to do a specific bisection of sched-devel.git:
> > 
> >    http://people.redhat.com/mingo/sched-devel.git/README
> 
> How do I know revision of git-sched.patch of 2.6.25-rc2-mm1? Should I 
> do bisect from HEAD of sched-devel.git?

yeah, please. If it's caused by sched-devel.git then you should see the 
hang there too.

	Ingo
