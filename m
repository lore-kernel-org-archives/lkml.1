Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbXDKXiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbXDKXiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbXDKXiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:38:22 -0400
Received: from lazybastard.de ([212.112.238.170]:48973 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbXDKXiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:38:22 -0400
Date: Thu, 12 Apr 2007 01:33:26 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Lang <david.lang@digitalinsight.com>, Neil Brown <neilb@suse.de>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070411233326.GD4893@lazybastard.org>
References: <17949.25061.739035.688232@notabene.brown> <Pine.LNX.4.63.0704111506040.28394@qynat.qvtvafvgr.pbz> <461D6DE9.9070601@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <461D6DE9.9070601@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 April 2007 16:23:21 -0700, H. Peter Anvin wrote:
> David Lang wrote:
> >On Thu, 12 Apr 2007, Neil Brown wrote:
> >
> >>For the second.
> >> You say that you " would need at least 96 bits in order to make that
> >> guarantee; 64 bits of hash, plus a 32-bit count value in the hash
> >> collision chain".  I think 96 is a bit greedy.  Surely 48 bits of
> >> hash and 16 bits of collision-chain-position would plenty.  You would
> >> need 65537 entries before a collision was even possible, and
> >> billions before it was at all likely. (How big does a set of 48bit
> >> numbers have to get before the probability that "No subset of 65536
> >> numbers are all the same" drops below 0.95?)
> >
> >  you can get a hash collision with two entries.
> 
> Yes, but the probability is 2^-n for an n-bit hash, assuming it's 
> uniformly distributed.
> 
> The probability approaches 1/2 as the number of entries hashes 
> approaches 2^(n/2) (birthday number.)

I believe you are both barking up the wrong tree.  Neil proposed a 16bit
collision chain.  With that, it takes 65537 entries before a collision
chain overflow is possible.

Calling a collision chain overflow "collision" is inviting confusion, of
course. :)

Jörn

-- 
The competent programmer is fully aware of the strictly limited size of
his own skull; therefore he approaches the programming task in full
humility, and among other things he avoids clever tricks like the plague.
-- Edsger W. Dijkstra
