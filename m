Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZEXPnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZEXPnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZEXPnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:43:12 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:54632 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZEXPnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:43:11 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sun, 24 May 2009 10:43:07 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <200905230544.54657.lkml@morethan.org> <20090524070415.GI20452@prithivi.gnumonks.org>
In-Reply-To: <20090524070415.GI20452@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905241043.10747.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 24 2009, Harald Welte wrote:
> On Sat, May 23, 2009 at 05:44:52AM -0500, Michael S. Zick wrote:
> 
> > *) The HP-2133 MiniNote uses the cn896 chipset, which
> > has not yet been released from NDA.
> 
> I can see towards getting that changed, but I doubt this helps us with the
> current problem.
> 
> > I do not have the C7-M technical reference, it is still
> > under NDA.
> 
> I obviously have access to that documentation (which is also on its way
> to become public, but needs more time) - but believe me, there is nothing
> in that documentation that would help you to debug this problem :(
> 
> > *But* if a developer on this list has a copy of the
> > manual *and* owns one of these three brands of machine -
> > they would have fixed their own machine a year ago.
> 
> I actually own a 2133 mininote, but I rarely used it for anything but to test
> openchrome on it.  What do you suggest me to try?
>

The {,lk} pair of yesterday - now built against tag 2.6.3-rc7 is
posted as -09144{,lk}

Details here:
http://forum.netbookuser.com/viewtopic.php?pid=6976#p6976

Try them on a C7-M/CX700 (or newer NetBook system chipset)
(I don't normally test on the HP-2133 (C7-M/CN896) since I am
not (yet) dealing with the Broadcom firmware and SBB driver.)

Mike
> I also have some other systems with a C7-M, so I can certainly verify
> certain code on a number of them, if a good testcase exists.
> 


