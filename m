Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYENVdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYENVdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbYENVdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:33:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34160 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755313AbYENVdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:33:13 -0400
Date: Wed, 14 May 2008 14:33:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <20080514212130.GD9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805141426440.19073@schroedinger.engr.sgi.com>
References: <4825709A.2020407@firstfloor.org> <20080510221515.3540a6cc@bree.surriel.com>
 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com>
 <20080514205842.GC9921@parisc-linux.org> <Pine.LNX.4.64.0805141359420.18958@schroedinger.engr.sgi.com>
 <20080514212130.GD9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Matthew Wilcox wrote:

> > No. I thought you were satisfied with the performance increase you saw 
> > when pinning the process to a single processor?
> 
> Er, no.  That program emulates a TPC-C run from the point of view of
> doing as much IO as possible from all CPUs.  Pinning the process to one
> CPU would miss the point somewhat.

Oh. The last message I got was an enthusiatic report on the performance 
gains you saw by pinning the process after we looked at slub statistics 
that showed that the behavior of the tests was different from your 
expectations. I got messages here that indicate that this was a scsi 
testing program that you had under development. And yes we saw the remote 
freeing degradations there.

> I seem to remember telling you that you might get more realistic
> performance numbers by pinning the scsi_ram_0 kernel thread to a single
> CPU (ie emulating an interrupt tied to one CPU rather than letting the
> scheduler choose to run the thread on the 'best' CPU).

If this is a stand in for the TPC then why did you not point that 
out when Pekka and I recently asked you to retest some configurations?
