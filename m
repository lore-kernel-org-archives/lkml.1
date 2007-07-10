Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbXGJBn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbXGJBn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXGJBnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:43:49 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:23886 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752877AbXGJBns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:43:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=W0W8pRRhqLMuJExx7akkivK8tddrXjCWN6B3pH0YLxtry/zHzjbNw0dfKk9rQRExUHmqlmPIFokwqxfk27aWE8fyuAdZeHGMRo1WPlT0kPrBoLkNAEyAwgg9hTYvr59ve1Xri1Au3uJTz2GRuPV4ZRdATG4sjRFGGsO458pcQOA=  ;
X-YMail-OSG: 3EobsOgVM1nUOzaawSyupJF5j7fn3gnbQl6VJdzX8oaVCOMFeTE5allePnNy_XIRw9bQN7H2HQ--
Message-ID: <4692E44E.6000606@yahoo.com.au>
Date: Tue, 10 Jul 2007 11:43:42 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <20070709095116.c2ea700f.akpm@linux-foundation.org> <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 9 Jul 2007, Andrew Morton wrote:

> I think the advantage that SLOB generates here is pretty minimal and is 
> easily offset by the problems of maintaining SLOB.

I don't get it. Have you got agreement from the small memory people
that the advantages of SLOB are pretty minimal, or did you just
decide that? If the latter, did you completely miss reading my email?
What happens to the people who jump through hoops to save 1 or 2 K?

I don't see any problems with maintaining SLOB. It is simple enough
that I was able to write a userspace test harness for it and hack
away at it after reading the code the first time for half an hour or
so. It is nothing even slightly comparable to the problems of SLAB,
for example. And you don't have to maintain it at all anyway!

I like removing code as much as the next person, but I don't
understand why you are so intent on removing SLOB and willing to
dismiss its advantages so quickly.

-- 
SUSE Labs, Novell Inc.
