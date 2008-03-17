Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYCQRdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYCQRdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYCQRcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:32:54 -0400
Received: from 1wt.eu ([62.212.114.60]:2510 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYCQRcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:32:53 -0400
Date: Mon, 17 Mar 2008 18:30:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: david@lang.hm
Cc: Daniel Phillips <phillips@phunq.net>,
       David Newall <davidn@davidnewall.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080317173001.GD18229@1wt.eu>
References: <200803092346.17556.phillips@phunq.net> <200803162252.58274.phillips@phunq.net> <alpine.DEB.1.00.0803162341340.14887@asgard.lang.hm> <200803170116.19546.phillips@phunq.net> <alpine.DEB.1.00.0803170740440.14887@asgard.lang.hm> <alpine.DEB.1.00.0803171021300.17640@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803171021300.17640@asgard.lang.hm>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 10:23:10AM -0700, david@lang.hm wrote:
> On Mon, 17 Mar 2008, david@lang.hm wrote:
> 
> >On Mon, 17 Mar 2008, Daniel Phillips wrote:
> >
> >>On Sunday 16 March 2008 23:49, david@lang.hm wrote:
> >>>>Mirroring on the other hand, makes a realtime copy of a volume, that is
> >>>>never out of date.
> >>>
> >>>so just mirror to a local disk array then.
> >>
> >>Great idea.  Except that the disk array has millisecond level latency,
> >>when what we trying to achieve is microsecond level latency.
> >>
> >>>a local disk array has more write bandwidth than a network connection to 
> >>>a
> >>>remote machine, so if you can mirror to a remote machine you can mirror 
> >>>to
> >>>a local disk array.
> >>
> >>So you could potentially connect to a _huge_ disk array and write deltas
> >>to it.  The disk array would have to support roughly 3 Gbytes/second of
> >>write bandwidth to keep up with the Violin ramdisk.  Doable, but you are
> >>now in the serious heavy iron zone.
> >
> >your network will do less then 1 Gbit/sec, so to mirror in real-time (what 
> >you claim is trivial) you would need at least 24 network connections in 
> >parallel. that's a LOT harder to setup then a high performance disk array.
> 
> by the way, the only way to get this much bandwideth between two machines 
> is to directly connect PCI-e/16 card slots togeather. this is definantly 
> not commodity hardware anymore (if it's even possible, PCI-e has some very 
> short distance limitations)

You can do that with 3 10GE NICS, though in practise that's not easy. 

Willy

