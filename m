Return-Path: <linux-kernel-owner+w=401wt.eu-S1945908AbXDLGMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945908AbXDLGMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 02:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945910AbXDLGMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 02:12:50 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:46850 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1945908AbXDLGMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 02:12:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=PD5bhsL+U/0muwde0vgWAsjUgrEYFDc9hPdjJOVgOznmHtL7+NU5jgA1E2/ZNHx7qFGYsjqlAVX8HMHG0Q6BxzPoQCsqUvoXvwPo6iSyzGt4HfHoR7Fip3k9eGp01gGmgCSgjWKI0G/Sj4Gtl1GqdaAHjac87vvemIteKgYgSMk=  ;
X-YMail-OSG: JofyAPwVM1lNhZPJYPqjxhxD9GUOosvg7iWTPW1xMwZNnNOF
Message-ID: <461DCDDA.2030502@yahoo.com.au>
Date: Thu, 12 Apr 2007 16:12:42 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
References: <461C6452.1000706@redhat.com> <461D6413.6050605@cosmosbay.com> <461D67A9.5020509@redhat.com> <461DC75B.8040200@cosmosbay.com> <461DCCEB.70004@yahoo.com.au>
In-Reply-To: <461DCCEB.70004@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Eric Dumazet wrote:
> 

>>> Two things can happen here.
>>>
>>> If this program used the pages before the kernel needed
>>> them, the program will be reusing its old pages.
>>
>>
>>
>> ah ok, this is because accessed/dirty bits are set by hardware and not 
>> a page fault.
> 
> 
> No it isn't.

That is to say, it isn't required for correctness. But if the
question was about avoiding a fault, then yes ;)

But as Linus recently said, even hardware handled faults still
take expensive microarchitectural traps.

> 
>> Is it true for all architectures ?
> 
> 
> No.
> 


-- 
SUSE Labs, Novell Inc.
