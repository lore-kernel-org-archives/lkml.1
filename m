Return-Path: <linux-kernel-owner+w=401wt.eu-S1161309AbXDKWjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161309AbXDKWjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161310AbXDKWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:39:10 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:63687 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1161309AbXDKWjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:39:09 -0400
Date: Wed, 11 Apr 2007 15:06:44 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Neil Brown <neilb@suse.de>
cc: Theodore Tso <tytso@mit.edu>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: <17949.25061.739035.688232@notabene.brown>
Message-ID: <Pine.LNX.4.63.0704111506040.28394@qynat.qvtvafvgr.pbz>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com><200
 70407203633.GA21555@thunk.org><20070407233037.GA16508@infradead.org><461930
 48.6000606@zytor.com><20070408184129.GA20871@lazybastard.org><17947.65165.5
 69482.976343@notabene.brown><20070411144252.GB17778@thunk.org>
 <17949.25061.739035.688232@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007, Neil Brown wrote:

> For the second.
>  You say that you " would need at least 96 bits in order to make that
>  guarantee; 64 bits of hash, plus a 32-bit count value in the hash
>  collision chain".  I think 96 is a bit greedy.  Surely 48 bits of
>  hash and 16 bits of collision-chain-position would plenty.  You would
>  need 65537 entries before a collision was even possible, and
>  billions before it was at all likely. (How big does a set of 48bit
>  numbers have to get before the probability that "No subset of 65536
>  numbers are all the same" drops below 0.95?)

Neil,
   you can get a hash collision with two entries.

David Lang
