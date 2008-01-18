Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbYARAZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbYARAZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbYARAZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:25:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756810AbYARAZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:25:31 -0500
Date: Fri, 18 Jan 2008 01:24:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       bunk@kernel.org, Dave Kleikamp <shaggy@austin.ibm.com>,
       Takashi Iwai <tiwai@suse.de>, Shaohua Li <shaohua.li@intel.com>,
       Jay Vosburgh <fubar@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: 2.6.24-rc8-git1: Reported regressions from 2.6.23
Message-ID: <20080118002443.GA4821@elte.hu>
References: <200801180035.42878.rjw@sisk.pl> <20080117155809.7ebc3bb7.akpm@linux-foundation.org> <alpine.LFD.1.00.0801171606300.2957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801171606300.2957@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > > Subject	: jiffies counter leaps in 2.6.24-rc3
> > > Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
> > > Date	: 2007-11-29 08:36
> > > References	: http://lkml.org/lkml/2007/11/24/53
> > > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
> > > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > > Patch	: http://lkml.org/lkml/2007/12/7/132
> 
> I think this is just the printk timestamp, no? And I think Ingo fixed 
> it differently.

yes. Stefano said the b43 driver is OK. The full fix is queued up for 
2.6.25. (it involved changing printk.c, etc., which didnt seem warranted 
- especially since the use of sched_clock() by printk was already quite 
incorrect.)

	Ingo
