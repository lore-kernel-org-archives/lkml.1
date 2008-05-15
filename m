Return-Path: <linux-kernel-owner+w=401wt.eu-S1764886AbYEOSwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764886AbYEOSwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764376AbYEOSvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:51:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37133 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764360AbYEOSvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:51:32 -0400
Date: Thu, 15 May 2008 12:51:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080515185130.GR9921@parisc-linux.org>
References: <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com> <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com> <20080515174953.GN9921@parisc-linux.org> <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com> <20080515181356.GP9921@parisc-linux.org> <Pine.LNX.4.64.0805151141510.19915@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805151141510.19915@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 11:43:40AM -0700, Christoph Lameter wrote:
> On Thu, 15 May 2008, Matthew Wilcox wrote:
> 
> > > Details of the crash please?
> > 
> > I don't have any.
> 
> Well the amount of information we are getting has always been the main 
> factor in delaying this further and further. Sigh.

Or possibly your assumptions have been the main factor.  I gave you a
reproducer for this problem 6 weeks ago.  As far as I can tell, you
haven't run it since.

> > > You could just start with 2.6.25.X which already contains the slab 
> > > statistics.
> > 
> > Certainly.  Exactly how does collecting these stats work?  Am I supposed
> > to zero the counters after the TPC has done its initial ramp-up?  What
> > commands should I run, and at exactly which points?
> 
> Compile slabinfo and then do f.e. slabinfo -AD (this is documented in the 
> help text provided when enabling statistics).

That's an utterly unhelpful answer.  Let me try asking again.

Exactly how does collecting these stats work?  Am I supposed to zero
the counters after the TPC has done its initial ramp-up?  What commands
should I run, and at exactly which points?

Otherwise I'll get something wrong and these numbers will be useless to
you.  Or that's what you'll claim anyway.

For reference the helptext says:

          SLUB statistics are useful to debug SLUBs allocation behavior in
          order find ways to optimize the allocator. This should never be
          enabled for production use since keeping statistics slows down
          the allocator by a few percentage points. The slabinfo command
          supports the determination of the most active slabs to figure
          out which slabs are relevant to a particular load.
          Try running: slabinfo -DA

By the way, when you say 'compile slabinfo', you mean the file shipped
as Documentation/vm/slabinfo.c (rather than, say, something out of tree?)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
