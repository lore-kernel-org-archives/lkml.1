Return-Path: <linux-kernel-owner+w=401wt.eu-S937906AbXGLAep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937906AbXGLAep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936026AbXGLAdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:33:38 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:31905 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758196AbXGLAdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:33:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vkz3pRcXTImQfrmz/OaGwO+pd4FVunpHRg8yU0l6z7+21T75co3eEAmCa8GQ0rlqEDqvVWZlmCrkrZBZRk6x3t8EXi0c1DaAsoSh9WqV4LO4zq45aEwKocbMP6+HCj5ld5f7uJ8gKHYrC/2H2x1/4sKRxW6tCYITQoO43lUfj/o=  ;
X-YMail-OSG: DqxcJAQVM1kvndh6LZVzjrLzvfrBl33fXxhM9dsjzPatZGPXb9v9izzrRpKAWekREivDbOWD0A--
Message-ID: <469576D8.7060608@yahoo.com.au>
Date: Thu, 12 Jul 2007 10:33:28 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <20070709095116.c2ea700f.akpm@linux-foundation.org> <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com> <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com> <4692E8B5.3030404@yahoo.com.au> <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com> <20070710083212.GG11115@waste.org> <Pine.LNX.4.64.0707101836280.7011@schroedinger.engr.sgi.com> <20070711020646.GZ11115@waste.org> <Pine.LNX.4.64.0707111104370.14730@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0707112121130.17548@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0707112121130.17548@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> Hi Christoph,
> 
> On Wed, 11 Jul 2007, Christoph Lameter wrote:
> 
>>Of course you are the maintainer but you only authored a single patch 
>>which was the original submission in all the time that SLOB was in the 
>>tree. I keep having to clean up the allocator that has--according to 
>>Pekka--more memory requirements than SLUB. There is no point in keeping it 
>>around anymore it seems.
> 
> 
> Well, it was a test setup with UML and busybox and didn't have all the 
> SLOB optimizations Nick mentioned, so we shouldn't draw any definite 
> conclusions from it. I couldn't get 2.6.22-rc6-mm1 to compile so I'll try 
> again after Andrew pushes a new release out.
> 
> Furthermore, as much as I would like to see SLOB nuked too, we can't do 
> that until Matt and Nick are satisfied with SLUB for small devices and 
> what I can gather, they aren't.

Just to be clear: I do really like SLUB of course. And if that was able
to get as good or nearly as good (for appropriate values of nearly) memory
efficiency as SLOB in relevant situations, that would be fantastic and
SLOB could go away.

I don't really have a good knowledge of small memory devices being used,
other than apparently they can boot with 2MB (maybe less with nommu?). So
even a few K could be very significant for these.

-- 
SUSE Labs, Novell Inc.
