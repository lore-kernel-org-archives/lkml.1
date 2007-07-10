Return-Path: <linux-kernel-owner+w=401wt.eu-S1762669AbXGJHJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669AbXGJHJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXGJHJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:09:41 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:20278 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751971AbXGJHJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:09:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gWbydkuVqBtBns26I5WYzqXHJP7/ggCgDiieHfL05RY6RZjstclNPKdT4x8UVAl5hc6qabxlUbYrk87GDLdxkuhAXpODFO8SnzOUeqzuPNmdHbE6vAQtgvay6sN1lISWhcm0j6R4NVu+USj2XF0nm1JJOvUaZ2QRoZIcgSTBxCA=  ;
X-YMail-OSG: JfuZ2rIVM1ltbX_cM376YHUovygNwlci4GG6lUYuNsk8zMn8zZT_e5J_.fjntdAKi4If1FIDjg--
Message-ID: <469330AD.5070107@yahoo.com.au>
Date: Tue, 10 Jul 2007 17:09:33 +1000
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
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <20070709095116.c2ea700f.akpm@linux-foundation.org> <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com> <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com> <4692E8B5.3030404@yahoo.com.au> <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 10 Jul 2007, Nick Piggin wrote:
> 
> 
>>It is reasonable to expect some help from maintainers, but I notice you
>>didn't even CC the SLOB maintainer in the patch to remove SLOB! So maybe
>>if you tried working a bit closer with him you could get better results?
> 
> 
> The maintainers last patch to SLOB was the initial submission of the 
> allocator. Then he acked subsequent patches. Most of the modifications to 
> SLOB are my work. Attempts to talk to the maintainer result in inventive 
> explanations why SLOB does not have to conform to kernel standards. There 
> is no reasonable expectation that this will change.

Well I really don't want to mediate, but even in the case of a
completely MIA maintainer, that isn't really a good idea to throw out
working and useful code.

But last time this discussion came up, IIRC you ended up handwaving
about all the ways in which SLOB was broken but didn't actually come
up with any real problems. Matt seemed willing to add those counters
or whatever it was if/when doing so solved a real problem. And remember
that SLOB doesn't have to have feature parity with SLUB, so long as it
implements the slab API such that the kernel *works*.

-- 
SUSE Labs, Novell Inc.
