Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbYCHImR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbYCHImR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 03:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYCHIl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 03:41:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37866 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYCHIl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 03:41:58 -0500
Date: Sat, 8 Mar 2008 09:41:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: suresh.b.siddha@intel.com, rjw@sisk.pl, akpm@linux-foundation.org,
       dmitry.adamushko@gmail.com, ego@in.ibm.com, oleg@sign.ru,
       yi.y.yang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] adjust root-domain->online span in response to hotplug
	event
Message-ID: <20080308084118.GA24552@elte.hu>
References: <20080308015045.GB15909@linux-os.sc.intel.com> <20080308050627.4831.87630.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308050627.4831.87630.stgit@novell1.haskins.net>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

>    Unfortunately, this patch will introduce its own set of bugs. 
> However, your analysis was spot-on.  I think I see the problem now.  
> It was introduced when I put a hack in to "fix" s2ram problems in -mm 
> as a result of the new root-domain logic.  I think the following patch 
> will fix both issues:
> 
> (I verified that I could take a cpu offline/online, but I don't have 
> an s2ram compatible machine handy.  Andrew, I believe you could 
> reproduce the s2ram problem a few months ago when that issue popped 
> up.  So if you could, please verify that s2ram also works with this 
> patch applied, in addition to the hotplug problem.

thanks Gregory, i've queued up your fix. If it passes all tests over the 
day i'll send it to Linus in about 12 hours.

	Ingo
