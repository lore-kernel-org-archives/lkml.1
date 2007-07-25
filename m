Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbXGYGar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbXGYGar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbXGYGak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:30:40 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:48914 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753841AbXGYGaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:30:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=G3l+qtBWRWLv0DlHNIkpHZ+lDwBi/Is6mjcmKimF52MsIP9hunwq/gF9+5TXRevkrrClJD8KITRFqpME5LRB2kgrDuHUzsHftVxf0Ks52UxOAq2jgH7BHYSrnwwtQSrtehQ3R1Rr0tZZFMRA5N/l4HiR53huV0ZdnJQzlNOM9rs=  ;
X-YMail-OSG: d5H2AJ0VM1lW_9xaINMYWWYPYFJSLpTJgKKCsppV64RVNqiOtNSum5VHiYVsNjAwYB.4Kyob1g--
Message-ID: <46A6EE09.1030307@yahoo.com.au>
Date: Wed, 25 Jul 2007 16:30:33 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matthew Hawkins <darthmdh@gmail.com>
CC: Eric St-Laurent <ericstl34@sympatico.ca>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org,
       Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	 <46A57068.3070701@yahoo.com.au>	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	 <46A58B49.3050508@yahoo.com.au>	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>	 <1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au> <b21f8390707242319gb17e4c9h274635b4c7fc1801@mail.gmail.com>
In-Reply-To: <b21f8390707242319gb17e4c9h274635b4c7fc1801@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Hawkins wrote:
> On 7/25/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> Not to say that neither fix some problems, but for such conceptually
>> big changes, it should take a little more effort than a constructed test
>> case and no consideration of the alternatives to get it merged.
> 
> 
> Swap Prefetch has existed since September 5, 2005.  Please Nick,
> enlighten us all with your "alternatives" which have been offered (in
> practical, not theoretical form) in the past 23 months, along with
> their non-constructed benchmarks proving their case and the hordes of
> happy users and kernel developers who have tested them out the wazoo
> and given their backing.  Or just take a nice steaming jug of STFU.

The alternatives comment was in relation to the readahead based drop
behind patch,for which an alternative would be improving use-once,
possibly in the way I described.

As for swap prefetch, I don't know, I'm not in charge of it being
merged or not merged. I do know some people have reported that their
updatedb problem gets much better with swap prefetch turned on, and
I am trying to work on that too.

For you? You also have the alternative to help improve things yourself,
and you can modify your own kernel.

-- 
SUSE Labs, Novell Inc.
