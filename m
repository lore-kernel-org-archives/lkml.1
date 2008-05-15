Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYEOTa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYEOTa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYEOTaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:30:18 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50087 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYEOTaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:30:17 -0400
Date: Thu, 15 May 2008 13:29:59 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080515192959.GS9921@parisc-linux.org>
References: <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com> <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com> <20080515174953.GN9921@parisc-linux.org> <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com> <20080515181356.GP9921@parisc-linux.org> <Pine.LNX.4.64.0805151141510.19915@schroedinger.engr.sgi.com> <20080515185130.GR9921@parisc-linux.org> <Pine.LNX.4.64.0805151153440.20201@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805151153440.20201@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 12:09:06PM -0700, Christoph Lameter wrote:
> Assumptions may be the issue. My own "reproducer" for remote frees is 
> available from my git tree and I usually prefer to run my own. We 

No doubt you prefer to run a test which fails to show a problem with
your code.  How about you try running a test which does show a problem?

> discussed the results of that program last fall. You stated yesterday that 
> your code is proprietary. I am not sure what I am allowed to do with the 
> code. I did not know that it was proprietary before yesterday and I would 
> have just forwarded that code to Pekka yesterday if I would not have 
> caught that message in time.

I'm surprised you're so cavalier about copyright.  There was nothing in
that code which permitted you to redistribute it.

> I thought that what you provided it was a test program to exercise 
> and optimize the scsi subsystem?

Why would you think that?  The subject of the email was "Slub test
program".

> > > Compile slabinfo and then do f.e. slabinfo -AD (this is documented in the 
> > > help text provided when enabling statistics).
> > 
> > That's an utterly unhelpful answer.  Let me try asking again.
> > 
> > Exactly how does collecting these stats work?  Am I supposed to zero
> > the counters after the TPC has done its initial ramp-up?  What commands
> > should I run, and at exactly which points?
> 
> There is no way of zeroing the counters. Run slabinfo -AD after the 
> test application has been running for awhile. If you want a differential 
> then you have to take two datapoints.

Is a differential interesting to you?

> > Otherwise I'll get something wrong and these numbers will be useless to
> > you.  Or that's what you'll claim anyway.
> 
> No. I guess I will end up with a lot of guess work of what is going on on 
> the system since the information is limited for some reason.

They're your statistics.  Tell me what you need.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
