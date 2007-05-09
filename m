Return-Path: <linux-kernel-owner+w=401wt.eu-S969998AbXEICnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969998AbXEICnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXEICnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:43:22 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:26264 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753972AbXEICnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:43:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=S5zTLnGIqecDhVIRiQ0zB1BL1mfkow5d4Mw4FiruUm5LvlTw4fCg81eFjTUhBF5hW5UJ/YADzaGEgIuLCQAw85FRARW7KrzV4A1iQ/S+FwPxj6ZKsnJf3igY4dbQFbhcuD9RwXkV1B5cjTJHCofktRhPtuOcolxdK6Yu+OuMKUg=  ;
X-YMail-OSG: hQtUB6sVM1n56iIsn7ITK4VzSZgVO_i4Gc3J4KTvqVxWEOriO3nD7zFr8cjGbeJnMmBE1IhGqA--
Message-ID: <4641353F.2000408@yahoo.com.au>
Date: Wed, 09 May 2007 12:43:11 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net> <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com> <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com> <20070509021911.GB11115@waste.org> <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 8 May 2007, Matt Mackall wrote:
> 
> 
>>>>Yes. It can in fact put 512 8-byte objects in a 4k page. More
>>>
>>>So can SLUB.
>>
>>Not without at least a bit per-object of overhead. So you can either
>>fit 512 objects in 4160 bytes or 504 objects in 4k.
> 
> 
> Slub uses a linked list pointer in the page struct which is NULL if all 
> objects are allocated. There is no bit per object overhead.
> 
> 
>>For the kmalloc case, we do have an 8-byte header, which works out to
>>be about 1/8th of the slop that mainline kmalloc over SLAB has on
> 
> 
> Exactly. That overhead does not exist in SLUB. Thus SLOB is less efficient 
> than SLUB.

What you trade for that is that one page page can only serve one slab.
For small systems, I would not be surprised if that was less space
efficient, even just looking at kmalloc caches in isolation. Or do you
have numbers to support your conclusion?

-- 
SUSE Labs, Novell Inc.
