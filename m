Return-Path: <linux-kernel-owner+w=401wt.eu-S937437AbXHPBiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937437AbXHPBiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 21:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXHPBh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 21:37:58 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:25492 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751825AbXHPBh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 21:37:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=d+lasCtSolmh1w2GrKVd1xK4f8F3wYRl/SpE8uXwTXuRlxFiZiELCvGvff9Kl2cgZW5MgyS6OQg6oPsRlw4UegJR6ruC8zmXARq4PgB6USi94s21xqJbeZMZYYB/WOp3IV/y4KKW5CUL7Kv7u7de4kYjYEoUl3jwoTzA2U4hIT4=  ;
X-YMail-OSG: 6iql9Z0VM1l9dkPX8gmqddkCmunUsUkDQfboMC7Q1W9RcNJtVlR_kcjvFBDZKqNbSRFtyxDRfg--
Message-ID: <46C3AA70.9010000@yahoo.com.au>
Date: Thu, 16 Aug 2007 11:37:52 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Herbert Xu <herbert.xu@redhat.com>
CC: Chris Snook <csnook@redhat.com>, Andi Kleen <ak@suse.de>,
       sebastian@breakpoint.cc, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations
 already do.
References: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au> <46C3319F.4050809@redhat.com> <20070815234434.GC28775@gondor.apana.org.au>
In-Reply-To: <20070815234434.GC28775@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Wed, Aug 15, 2007 at 01:02:23PM -0400, Chris Snook wrote:
> 
>>Herbert Xu wrote:

>>>I'm still unconvinced why we need this because nobody has
>>>brought up any examples of kernel code that legitimately
>>>need this.
>>
>>There's plenty of kernel code that *wants* this though.  If we can 
> 
> 
> You keep saying this yet everytime I ask for an example I
> get nothing.

Agreed. Simplest thing to do will be to post those patches which
eliminate the register-clobbering barriers, shrink binaries, etc.
for all that code that wants this.

-- 
SUSE Labs, Novell Inc.
