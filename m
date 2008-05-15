Return-Path: <linux-kernel-owner+w=401wt.eu-S1764200AbYEOR6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764200AbYEOR6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764077AbYEOR6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:58:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52967 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754603AbYEOR6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:58:03 -0400
Date: Thu, 15 May 2008 10:58:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <20080515174953.GN9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com>
References: <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>
 <20080510221515.3540a6cc@bree.surriel.com> <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
 <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
 <20080515174953.GN9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Matthew Wilcox wrote:

> On Thu, May 15, 2008 at 10:05:35AM -0700, Christoph Lameter wrote:
> > Thanks for using the slab statistics. I wish I had these numbers for the 
> > TPC benchmark. That would allow us to understand what is going on while it 
> > is running.
> 
> Hang on, you want slab statistics for the TPC run?  You didn't tell me
> that.  We're trying to gather oprofile data (and having trouble because
> the machine crashes when we start using oprofile -- this is with the git
> tree you/pekka put together for us to test).

Well we talked about this when you send me the test program. I just 
thought that it would be logical to do the same for the real case.

Details of the crash please?

You could just start with 2.6.25.X which already contains the slab 
statistics.

Also re: the test program since pinning a process does increase the 
performance by orders of magnitude. Are you sure that the application was 
properly tuned for an 8p configuration? Pinning is usually not necessary 
for lower numbers of processors because the scheduler thrashing effect is 
less of an issue.  If the test program is an accurate representation of 
the TP-C benchmark then you can drastically increase its performance by 
doing the same to the real test.

