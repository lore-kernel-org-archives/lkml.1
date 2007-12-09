Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbXLISrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbXLISrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbXLISrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:47:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXLISrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:47:43 -0500
Date: Sun, 9 Dec 2007 19:47:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Pavel Machek <pavel@ucw.cz>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [git pull] x86/hrtimer/acpi fixes
Message-ID: <20071209184713.GA16628@elte.hu>
References: <20071207183633.GC26778@elte.hu> <1197053386.32023.13.camel@cmn3.stanford.edu> <20071207185920.GA3006@elte.hu> <1197055769.32023.22.camel@cmn3.stanford.edu> <1197056910.32023.25.camel@cmn3.stanford.edu> <20071207195958.GA12529@elte.hu> <20071209180149.GJ4381@ucw.cz> <3d8471ca0712091010p1dd0de12h4f9dd1037d87223@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0712091010p1dd0de12h4f9dd1037d87223@mail.gmail.com>
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


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> On Dec 9, 2007 7:01 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > > + *  ns += offset to avoid sched_clock jumps with cpufreq
> > > + *
> > >   *                   -johnstul@us.ibm.com "math is hard, lets go shopping!"
> > >   */
> >
> > Did john add the 'ns+=' or do comments need reorder?
> 
> I added it, but I think it needs to be removed as now the offset is 
> maintained by the scheduler in __update_rq_clock().

yeah, and it's already removed in latest x86.git.

	Ingo
