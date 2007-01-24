Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbXAXMvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbXAXMvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 07:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbXAXMvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 07:51:00 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:49067 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751365AbXAXMu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 07:50:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=d9wsn4Yz2y5ue6QkyQZVEdnVsDDI6JPL7U2RXcfSrrgHud7Jazp6gbXQsVnYKyqyTvSazFlOvKWg66S92QOGavkkl0pWW+5kLdYUZbfijyVw2W8RngYV3Xhyy9k+zV7cYxVYZVhM8r2ir3jEDUH2NBqfum0EEvSAeRNVWQn4+mQ=  ;
X-YMail-OSG: c9bnwsEVM1leKqg9bPy10zb3AmtwW6MR7ZjHnzCm1rK93pQMo0RVSNTvYN5vMRxabLc1dr9edA--
Message-ID: <45B7561C.9000102@yahoo.com.au>
Date: Wed, 24 Jan 2007 23:50:36 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Lameter <clameter@sgi.com>, Aubrey Li <aubreylee@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com> <1169625333.4493.16.camel@taijtu>
In-Reply-To: <1169625333.4493.16.camel@taijtu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2007-01-23 at 16:49 -0800, Christoph Lameter wrote:

>>2. Insure rapid turnaround of pages in the cache.

[...]

> The  only maybe valid point would be 2, and I'd like to see if we can't
> solve that differently - a better use-once logic comes to mind.

There must be something I'm missing with that point. The faster
the turnaround of pagecache pages, the *less* efficiently the
pagecache is working (assuming a rapid turnaround means a high
rate of pages brought into, then reclaimed from pagecache).

I can't argue that a smaller pagecache will be subject to a
higher turnaround given the same workload, but I don't know why
that would be a good thing.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
