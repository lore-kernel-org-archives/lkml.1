Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbXDKX1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbXDKX1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXDKX1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:27:46 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbXDKX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:27:45 -0400
Message-ID: <461D6DE9.9070601@zytor.com>
Date: Wed, 11 Apr 2007 16:23:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Lang <david.lang@digitalinsight.com>
CC: Neil Brown <neilb@suse.de>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com><200 70407203633.GA21555@thunk.org><20070407233037.GA16508@infradead.org><461930 48.6000606@zytor.com><20070408184129.GA20871@lazybastard.org><17947.65165.5 69482.976343@notabene.brown><20070411144252.GB17778@thunk.org> <17949.25061.739035.688232@notabene.brown> <Pine.LNX.4.63.0704111506040.28394@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0704111506040.28394@qynat.qvtvafvgr.pbz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang wrote:
> On Thu, 12 Apr 2007, Neil Brown wrote:
> 
>> For the second.
>>  You say that you " would need at least 96 bits in order to make that
>>  guarantee; 64 bits of hash, plus a 32-bit count value in the hash
>>  collision chain".  I think 96 is a bit greedy.  Surely 48 bits of
>>  hash and 16 bits of collision-chain-position would plenty.  You would
>>  need 65537 entries before a collision was even possible, and
>>  billions before it was at all likely. (How big does a set of 48bit
>>  numbers have to get before the probability that "No subset of 65536
>>  numbers are all the same" drops below 0.95?)
> 
> Neil,
>   you can get a hash collision with two entries.
> 

Yes, but the probability is 2^-n for an n-bit hash, assuming it's 
uniformly distributed.

The probability approaches 1/2 as the number of entries hashes 
approaches 2^(n/2) (birthday number.)

	-hpa
