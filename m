Return-Path: <linux-kernel-owner+w=401wt.eu-S935406AbXEICKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935406AbXEICKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXEICKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:10:32 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:38353 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753972AbXEICKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:10:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Y39EhisnnVK7309wWkydluuTE7Os4PKmF7lVIb+8U19MVzYhBgPoYj6AHjqflyiNYaDNOg3PpFttIjdvVaFvXc4a2ePn36irVNMWfXRRqE/OHK84wuw2gt3jWBB0SEwEittXxRiTTCcxT/ovFHqQrTFeRyNrM491h21Fp1ZMq/k=  ;
Message-ID: <46412D8D.8090903@yahoo.com.au>
Date: Wed, 09 May 2007 12:10:21 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: clameter@sgi.com, mpm@selenic.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
References: <Pine.LNX.4.64.0705081852310.17784@schroedinger.engr.sgi.com>	<20070508.185539.95059076.davem@davemloft.net>	<Pine.LNX.4.64.0705081856110.17784@schroedinger.engr.sgi.com> <20070508.190610.08324075.davem@davemloft.net>
In-Reply-To: <20070508.190610.08324075.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Christoph Lameter <clameter@sgi.com>
> Date: Tue, 8 May 2007 18:57:04 -0700 (PDT)
> 
> 
>>On Tue, 8 May 2007, David Miller wrote:
>>
>>
>>>I'm just reading over the code to figure out what to type to you, you
>>>could read the code too it's not very complicated :-)
>>
>>I have read it numerous times and my conclusion is that it uses the 
>>descriptors for that purpose. But Matt claims they are not necessary. So I 
>>am just trying to figure out how one can get to that conclusion.
> 
> 
> He is saying the metadata is not necessary for allocated objects.
> At least that's my take.

Right. You only need to know blob boundaries for free blobs (so you can
allocate from or merge to). For allocated blobs, you know the start
(which is the address of the memory), and the end (which is the start +
the size contained in kmem_cache structure).

-- 
SUSE Labs, Novell Inc.
