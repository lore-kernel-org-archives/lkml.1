Return-Path: <linux-kernel-owner+w=401wt.eu-S1762671AbYEPTHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762671AbYEPTHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762443AbYEPTGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:06:55 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39689 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762430AbYEPTGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:06:53 -0400
Date: Fri, 16 May 2008 12:06:47 -0700 (PDT)
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
In-Reply-To: <20080515192959.GS9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805161203150.3393@schroedinger.engr.sgi.com>
References: <482B2617.5010605@firstfloor.org>
 <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
 <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
 <20080515174953.GN9921@parisc-linux.org> <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com>
 <20080515181356.GP9921@parisc-linux.org> <Pine.LNX.4.64.0805151141510.19915@schroedinger.engr.sgi.com>
 <20080515185130.GR9921@parisc-linux.org> <Pine.LNX.4.64.0805151153440.20201@schroedinger.engr.sgi.com>
 <20080515192959.GS9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Matthew Wilcox wrote:

> On Thu, May 15, 2008 at 12:09:06PM -0700, Christoph Lameter wrote:
> > Assumptions may be the issue. My own "reproducer" for remote frees is 
> > available from my git tree and I usually prefer to run my own. We 
> 
> No doubt you prefer to run a test which fails to show a problem with
> your code.  How about you try running a test which does show a problem?

The test was designed to show the worst case effect of the additional 
atomic op and it does its job. Look at the tests branch of my vm git tree.

> > There is no way of zeroing the counters. Run slabinfo -AD after the 
> > test application has been running for awhile. If you want a differential 
> > then you have to take two datapoints.
> 
> Is a differential interesting to you?

Depends on how much other stuff is going on before.

> 
> > > Otherwise I'll get something wrong and these numbers will be useless to
> > > you.  Or that's what you'll claim anyway.
> > 
> > No. I guess I will end up with a lot of guess work of what is going on on 
> > the system since the information is limited for some reason.
> 
> They're your statistics.  Tell me what you need.

The output of slabinfo -AD.... 


