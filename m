Return-Path: <linux-kernel-owner+w=401wt.eu-S1161360AbXDLAAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161360AbXDLAAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 20:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161410AbXDLAAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 20:00:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:55409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161360AbXDLAAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 20:00:53 -0400
From: Neil Brown <neilb@suse.de>
To: David Lang <david.lang@digitalinsight.com>
Date: Thu, 12 Apr 2007 10:00:30 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17949.30366.645476.893772@notabene.brown>
Cc: Theodore Tso <tytso@mit.edu>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: message from David Lang on Wednesday April 11
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	<200
 70407203633.GA21555@thunk.org>
	<20070407233037.GA16508@infradead.org>
	<461930
 48.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
	<17947.65165.5
 69482.976343@notabene.brown>
	<20070411144252.GB17778@thunk.org>
	<17949.25061.739035.688232@notabene.brown>
	<Pine.LNX.4.63.0704111506040.28394@qynat.qvtvafvgr.pbz>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday April 11, david.lang@digitalinsight.com wrote:
> On Thu, 12 Apr 2007, Neil Brown wrote:
> 
> > For the second.
> >  You say that you " would need at least 96 bits in order to make that
> >  guarantee; 64 bits of hash, plus a 32-bit count value in the hash
> >  collision chain".  I think 96 is a bit greedy.  Surely 48 bits of
> >  hash and 16 bits of collision-chain-position would plenty.  You would
> >  need 65537 entries before a collision was even possible, and
> >  billions before it was at all likely. (How big does a set of 48bit
> >  numbers have to get before the probability that "No subset of 65536
> >  numbers are all the same" drops below 0.95?)
> 
> Neil,
>    you can get a hash collision with two entries.

You need at least 65537 entries before there is any possibility of
collision between two
   "48-bit-hash ++ 16-bit-sequence-number"
objects where the 16-bit-sequence-number is chosen to be different from all
other 16 bit sequence numbers combined with the same 48 bit hash.

NeilBrown
