Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbYARONg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbYARONg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbYARON3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:13:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbYARON2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:13:28 -0500
Date: Fri, 18 Jan 2008 15:12:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bunk@kernel.org, Dave Kleikamp <shaggy@austin.ibm.com>,
       Takashi Iwai <tiwai@suse.de>, Shaohua Li <shaohua.li@intel.com>,
       Jay Vosburgh <fubar@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: 2.6.24-rc8-git1: Reported regressions from 2.6.23
Message-ID: <20080118141224.GA16963@elte.hu>
References: <200801180035.42878.rjw@sisk.pl> <20080117155809.7ebc3bb7.akpm@linux-foundation.org> <alpine.LFD.1.00.0801171606300.2957@woody.linux-foundation.org> <200801181510.10180.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181510.10180.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > > > Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
> > > > Submitter	: Roland Dreier <rdreier@cisco.com>
> > > > Date		: 2007-11-08 14:55
> > > > References	: http://lkml.org/lkml/2007/11/8/255
> > > > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
> > > > Handled-By	: Takashi Iwai <tiwai@suse.de>
> > > > 		  Ingo Molnar <mingo@elte.hu>
> > > > Patch		: http://lkml.org/lkml/2007/11/16/66
> > 
> > This patch went in, but was reverted because it caused more problems than 
> > it fixed. And what it "fixed" was somewhat dubious anyway.
> 
> It was reported to break suspend on one box, but Takashi wants it in, 
> AFAICS, as quite some time has been invested into figuring out what's 
> going wrong in that case.

since this is about a weird, not fully understood hardware interfacing 
and timing problem, and because my original fix was not really a 
regression fix (but it indeed _caused_ a real regression in a previously 
working setup), i'd lean towards just reverting my patch in .24 and 
going with Takashi's fixes in .25. I.e. the current -git status quo.

	Ingo
