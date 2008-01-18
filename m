Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbYAROdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbYAROdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYAROdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:33:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933AbYAROdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:33:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc8-git1: Reported regressions from 2.6.23
Date: Fri, 18 Jan 2008 15:35:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
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
References: <200801180035.42878.rjw@sisk.pl> <200801181510.10180.rjw@sisk.pl> <20080118141224.GA16963@elte.hu>
In-Reply-To: <20080118141224.GA16963@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181535.44380.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 18 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > > > Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
> > > > > Submitter	: Roland Dreier <rdreier@cisco.com>
> > > > > Date		: 2007-11-08 14:55
> > > > > References	: http://lkml.org/lkml/2007/11/8/255
> > > > > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
> > > > > Handled-By	: Takashi Iwai <tiwai@suse.de>
> > > > > 		  Ingo Molnar <mingo@elte.hu>
> > > > > Patch		: http://lkml.org/lkml/2007/11/16/66
> > > 
> > > This patch went in, but was reverted because it caused more problems than 
> > > it fixed. And what it "fixed" was somewhat dubious anyway.
> > 
> > It was reported to break suspend on one box, but Takashi wants it in, 
> > AFAICS, as quite some time has been invested into figuring out what's 
> > going wrong in that case.
> 
> since this is about a weird, not fully understood hardware interfacing 
> and timing problem, and because my original fix was not really a 
> regression fix (but it indeed _caused_ a real regression in a previously 
> working setup), i'd lean towards just reverting my patch in .24 and 
> going with Takashi's fixes in .25. I.e. the current -git status quo.

Agreed.

Rafael
