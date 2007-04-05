Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXDEBuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXDEBuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 21:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbXDEBuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 21:50:18 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:36775 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752308AbXDEBuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 21:50:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=zlXHWhPShzPivoq4IVfXkokPJ0nBxbXyfEvyq7IB8K9jRdaIB0N6xbanIb6JbdBDAEjmqm9QdhMY6inLhRrNw9aPsoTFXQqTihtcBb+B2jcTVJGfY3UthM6hi2gqlcxEGzTOLhl6oeQeFLW3fedQxg6haUgejjoDBUnVDe+TtN0=  ;
X-YMail-OSG: YSQo0rMVM1kbJEjz2qlwz1C1nHA8pHgCzmQYI0cNkg8o5hb.C1EapQ3vsjon48RfzFSw.bJfCyOBGoKGgovGBhWfaXWFaicezwmOWT5Bp_HemQKCr5TuJcqtPsf6NEAp.ZSKBxg014XG4hY-
Message-ID: <461455D4.6040602@yahoo.com.au>
Date: Thu, 05 Apr 2007 11:50:12 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps: Move the page walker code to lib/
References: <7.486631555@selenic.com> <461320C9.5030601@yahoo.com.au> <20070404050857.GU4892@waste.org> <46133CC0.505@yahoo.com.au> <20070404214828.GA4892@waste.org> <461451A2.8020708@yahoo.com.au>
In-Reply-To: <461451A2.8020708@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Matt Mackall wrote:
> 
>> On Wed, Apr 04, 2007 at 03:50:56PM +1000, Nick Piggin wrote:

>>> Just put it in its own file in mm/ rather than its own file in lib.
>>> lib should be for almost-standalone stuff, IMO (ie. only using basic
>>> kernel functionality).
>>
>>
>>
>> Arguably that's what lib/ should be for, but it's currently largely
> 
> 
> I disagree. There is code everywhere that exists to provide some
> functionality via an API to other parts of the kernel. You don't
> think mm/page_alloc.c should go in lib/?

Oh, I think I misunderstood you.

Anyway, we have lots of conditionally compiled code in mm as well.
It doesn't seem to be much hardship.

-- 
SUSE Labs, Novell Inc.
