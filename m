Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZEXHT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZEXHT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZEXHTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:19:19 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:42386 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZEXHTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:19:19 -0400
Date: Sun, 24 May 2009 14:49:05 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: lkml@morethan.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090524064905.GH20452@prithivi.gnumonks.org>
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A188A48.5000208@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear hpa, and others,

On Sat, May 23, 2009 at 04:44:08PM -0700, H. Peter Anvin wrote:
> It looks like there might be a problem with the C7-M ... Michael reports
> that if he sets LOCK_PREFIX to "lock;" it works, but that shouldn't be
> necessary for a uniprocessor.
> 

I will try my best to help, though I have to admit I'm far from being
a x86 expert, and particularly not with regard to low-level bits such as atomic
operations.

So please give me some time to research some background about that,
and read up all the details on the currently reported/described problem.

Once I understand it in full detail, I can talk to the right people inside
CentaurLabs (VIA's CPU division).  

If somebody (optionally) can phrase a precise technical question that I can
directly forward to somebody with low-level x86 knowledge but no Linux background,
it would definitely help speeding up the process.

> I'm wondering if we have to revive the OOSTORE hack, or some other
> workaround.  It is of course hard for me to track this down since (a) I
> don't have access to the CPU documentation, 

As far as I know, there really is no such documentation.. all documentation
that I've ever seen internally is electrical data sheets and high-level feature
set descriptiosn, CPUID, MSR and padlock.  There are no  actual x86 instruction
set documents... Centaur is < 100 people, they don't have the resources to work
on documents along the lines of what Intel has...

> and (b) I work for Intel now, which limits the amount of time I can
> realistically spend on this.

Sure, thanks for letting me know.
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
