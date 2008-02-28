Return-Path: <linux-kernel-owner+w=401wt.eu-S1763221AbYB1Tde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763221AbYB1Tde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761524AbYB1TdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:33:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761437AbYB1TdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:33:20 -0500
Date: Thu, 28 Feb 2008 20:32:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kosaki.motohiro@jp.fujitsu.com, srostedt@redhat.com,
       Lee.Schermerhorn@hp.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, tony.luck@intel.com, mingo@redhat.com,
       bob.picco@hp.com, eric.whitney@hp.com
Subject: Re: 2.6.25-rc2-mm1 - boot hangs on ia64
Message-ID: <20080228193233.GA26735@elte.hu>
References: <20080227103831.423F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080227071118.GA4638@elte.hu> <20080228192509.BDCF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080228115041.GA22082@elte.hu> <20080228101343.1b9548e6.akpm@linux-foundation.org> <20080228191214.GA17872@elte.hu> <20080228112423.fed6add2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228112423.fed6add2.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > I don't think we shoudl have added that hack in the first place.  
> > > It solves a problem which about three developers hit four times in 
> > > five years but it has made kernel logging less reliable for 
> > > everyone.
> > 
> > well, the problem was ia64, not a problem on x86 or other platforms.
> 
> I am referring to the original change which made klogd wakeups 
> unreliable.

oh, indeed - agreed - i missed the fact that is_locked check is sporadic 
and can cause other CPUs to prevent the wakeup of klogd. I've zapped the 
change.

	Ingo
