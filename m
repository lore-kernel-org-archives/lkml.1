Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZEXMi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZEXMi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 08:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZEXMis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 08:38:48 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:57746 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZEXMir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 08:38:47 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sun, 24 May 2009 07:38:44 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <4A188A48.5000208@zytor.com> <20090524064905.GH20452@prithivi.gnumonks.org>
In-Reply-To: <20090524064905.GH20452@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905240738.47090.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 24 2009, Harald Welte wrote:
> Dear hpa, and others,
> 
> On Sat, May 23, 2009 at 04:44:08PM -0700, H. Peter Anvin wrote:
> > It looks like there might be a problem with the C7-M ... Michael reports
> > that if he sets LOCK_PREFIX to "lock;" it works, but that shouldn't be
> > necessary for a uniprocessor.
> > 
> 
> I will try my best to help, though I have to admit I'm far from being
> a x86 expert, and particularly not with regard to low-level bits such as atomic
> operations.
> 
> So please give me some time to research some background about that,
> and read up all the details on the currently reported/described problem.
> 
> Once I understand it in full detail, I can talk to the right people inside
> CentaurLabs (VIA's CPU division).  
> 
> If somebody (optionally) can phrase a precise technical question that I can
> directly forward to somebody with low-level x86 knowledge but no Linux background,
> it would definitely help speeding up the process.
> 
> > I'm wondering if we have to revive the OOSTORE hack, or some other
> > workaround.  It is of course hard for me to track this down since (a) I
> > don't have access to the CPU documentation, 
> 
> As far as I know, there really is no such documentation.. all documentation
> that I've ever seen internally is electrical data sheets and high-level feature
> set descriptiosn, CPUID, MSR and padlock.  There are no  actual x86 instruction
> set documents... Centaur is < 100 people, they don't have the resources to work
> on documents along the lines of what Intel has...
>

My background is in the electronic hardware end of things - -
Is there someone I can contact for the existing documents -
Even under NDA would be fine.

For instance, the layout of the CPUID results - they don't
currently seem to match what the marketing people claim is
inside of the chips.  There are some "VIA specific" fields.

Also, those funny looking electrical data sheets with the wiggly
lines will mean something to me in terms of when to use the
"lock" prefix.  All you have to do is grow up with such things. ;)
 
Could you also dig around for a tech manual on CN896 similar to
the one (of two) CX700 manuals that are publicly posted?
Even under NDA is fine.

> > and (b) I work for Intel now, which limits the amount of time I can
> > realistically spend on this.
> 

I might be able to get you a machine, but if you are scanned
at the front door for VIA or AMD hardware. . .  ;)

Mike
> Sure, thanks for letting me know.


