Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbXGJHEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbXGJHEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXGJHEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:04:07 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:47633 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752517AbXGJHEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:04:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=jLWHiXwCj6rsfyIlaK8VMXxoaLLjk8Xe8Ptek1/ftszRtavaPItSxvrQl8r4oHrcN0KRH0m/sid1qn13AFedQ3D62W/orXaFAYIkH9MrAJuNB7dbE3iEVQ1HXBuXHl2M4YX/RLyPz33q+GfKmg6w+VlbJgf2b5luuWx64zEjwVg=  ;
X-YMail-OSG: ESs72ZsVM1lYPsDRLZsSEou9jMJYxcSiud6qkQFPrK3_5FvN
Message-ID: <46932F5C.20709@yahoo.com.au>
Date: Tue, 10 Jul 2007 17:03:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <4692E3BF.9010305@yahoo.com.au> <Pine.LNX.4.64.0707091849590.2860@schroedinger.engr.sgi.com> <4692E7D4.6060909@yahoo.com.au> <20070710062215.GE11115@waste.org>
In-Reply-To: <20070710062215.GE11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, Jul 10, 2007 at 11:58:44AM +1000, Nick Piggin wrote:

>>Just a fancy way of saying roughly that memory waste will increase as
>>the size of the system increases. But that aspect of it I think is
>>not really a problem for non-tiny systems anyway because the waste
>>tends not to be too bad (and possibly the number of active allocations
>>does not increase O(n) with the size of RAM either).
> 
> 
> If active allocations doesn't increase O(n) with the size of RAM,
> what's all that RAM for?
> 
> If your memory isn't getting used for large VMAs or large amounts of
> page cache, that means it's getting used by task structs,
> radix_tree_nodes, sockets, dentries, inodes, etc.

Yeah you could be right. Actually you most likey _are_ right for many
workloads.

-- 
SUSE Labs, Novell Inc.
