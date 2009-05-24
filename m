Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZEXMsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZEXMsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 08:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZEXMsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 08:48:31 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:48740 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZEXMsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 08:48:30 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sun, 24 May 2009 07:48:26 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905230544.54657.lkml@morethan.org> <20090524070415.GI20452@prithivi.gnumonks.org>
In-Reply-To: <20090524070415.GI20452@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905240748.29600.lkml@morethan.org>
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

The HP-2133 (C7-M/CN896) did not fail yesterday.
Find a C7-M/CX700 machine.

You might hook the rss feed at:
http://forum.netbookuser.com/viewforum.php?id=8
where my rants/raves/speculations are logged and
the other people helping me test make their comments.

In particular:

The original instructions (including download url):
http://forum.netbookuser.com/viewtopic.php?pid=6702#p6702

Updated installation instructions:
http://forum.netbookuser.com/viewtopic.php?id=907 

Also ignore anything you read in LKML that I have been doing
this in secret - those authors just never got the memo. ;)

> I also have some other systems with a C7-M, so I can certainly verify
> certain code on a number of them, if a good testcase exists.
> 

Still working towards a specific test case - only thing at this
point it the sledge hammer of putting the "lock" back in, everywhere.

Mike

