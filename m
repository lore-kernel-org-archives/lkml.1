Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbXHFSvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbXHFSvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXHFSvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:51:47 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53623 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751874AbXHFSvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:51:46 -0400
Date: Mon, 6 Aug 2007 11:51:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Daniel Phillips <phillips@phunq.net>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <200708061148.43870.phillips@phunq.net>
Message-ID: <Pine.LNX.4.64.0708061150270.7603@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <200708061121.50351.phillips@phunq.net>
 <Pine.LNX.4.64.0708061141511.3152@schroedinger.engr.sgi.com>
 <200708061148.43870.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Daniel Phillips wrote:

> On Monday 06 August 2007 11:42, Christoph Lameter wrote:
> > On Mon, 6 Aug 2007, Daniel Phillips wrote:
> > > Currently your system likely would have died here, so ending up
> > > with a reserve page temporarily on the wrong node is already an
> > > improvement.
> >
> > The system would have died? Why?
> 
> Because a block device may have deadlocked here, leaving the system 
> unable to clean dirty memory, or unable to load executables over the 
> network for example.

So this is a locking problem that has not been taken care of?

