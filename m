Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYCQOjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYCQOjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 10:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYCQOjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 10:39:44 -0400
Received: from mail.lang.hm ([64.81.33.126]:50596 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbYCQOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:39:43 -0400
Date: Mon, 17 Mar 2008 07:42:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: David Newall <davidn@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803170116.19546.phillips@phunq.net>
Message-ID: <alpine.DEB.1.00.0803170740440.14887@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <200803162252.58274.phillips@phunq.net> <alpine.DEB.1.00.0803162341340.14887@asgard.lang.hm> <200803170116.19546.phillips@phunq.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Daniel Phillips wrote:

> On Sunday 16 March 2008 23:49, david@lang.hm wrote:
>>> Mirroring on the other hand, makes a realtime copy of a volume, that is
>>> never out of date.
>>
>> so just mirror to a local disk array then.
>
> Great idea.  Except that the disk array has millisecond level latency,
> when what we trying to achieve is microsecond level latency.
>
>> a local disk array has more write bandwidth than a network connection to a
>> remote machine, so if you can mirror to a remote machine you can mirror to
>> a local disk array.
>
> So you could potentially connect to a _huge_ disk array and write deltas
> to it.  The disk array would have to support roughly 3 Gbytes/second of
> write bandwidth to keep up with the Violin ramdisk.  Doable, but you are
> now in the serious heavy iron zone.

your network will do less then 1 Gbit/sec, so to mirror in real-time (what 
you claim is trivial) you would need at least 24 network connections in 
parallel. that's a LOT harder to setup then a high performance disk array.

David Lang
