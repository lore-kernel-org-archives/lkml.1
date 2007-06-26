Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbXFZCfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbXFZCfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbXFZCfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:35:17 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:22801 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752969AbXFZCfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:35:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Qg4A2Ui0dIVV4kpqZK4TY3DeeijWQY03AkpPENFt9ypOU6OoTLNJFgsczRT1lfb1xS1j27VGgGB74MZurLrTNZGn5FFA4hq/t54SBBX9S2NC8QlmTz88CdDMOwmRREayePOuXu0owY7CDgwSJXn3BDkUgHzTOyYtBhDng1EL17k=  ;
X-YMail-OSG: 8wuqpd0VM1nhTqxT_4SPnXNh1iU.6Mdb3HzrlxqBeCbxDsd_
Message-ID: <46807B5D.6090604@yahoo.com.au>
Date: Tue, 26 Jun 2007 12:35:09 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: vm/fs meetup in september?
References: <20070624042345.GB20033@wotan.suse.de> <20070625063545.GA1964@infradead.org>
In-Reply-To: <20070625063545.GA1964@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Jun 24, 2007 at 06:23:45AM +0200, Nick Piggin wrote:
> 
>>I'd just like to take the chance also to ask about a VM/FS meetup some
>>time around kernel summit (maybe take a big of time during UKUUG or so).
> 
> 
> I won't be around until a day or two before KS, so I'd prefer to have it
> after KS if possible.

I'd like to see you there, so I hope we can find a date that most
people are happy with. I'll try to start working that out after we
have a rough idea of who's interested.


>>I don't want to do it in the VM summit, because that kind of alienates
>>the filesystem guys. What I want to talk about is anything and everything
>>that the VM can do better to help the fs and vice versa.  I'd like to
>>stay away from memory management where not too applicable to the fs.
> 
> 
> As more of a filesystem person I wouldn't mind it being attached to a VM
> conf.  In the worst case we'll just rename it VM/FS conference.  When and
> where is it scheduled?

I'll just cc Martin, however the VM conference I think is pretty short
on filesystem people. I'd also like to avoid a lot of VM topics and
hopefully have enough time for a topic of interest or so from each fs
maintainer who has something to talk about.

But I'm open to ideas that will make it work better. FWIW, Anton has
offered to try arranging conference facilities at the university, so
I think we should be covered there.


>>- the address space operations APIs, and their page based nature. I think
>>  it would be nice to generally move toward offset,length based ones as
>>  much as possible because it should give more efficiency and flexibility
>>  in the filesystem.
>>
>>- write_begin API if it is still an issue by that date. Hope not :)
>>
>>- truncate races
>>
>>- fsblock if it hasn't been shot down by then
> 
> 
> Don't forget high order pagecache please.


Leaving my opinion of higher order pagecache aside, this _may_ be an
example of something that doesn't need a lot of attention, because it
should be fairly uncontroversial from a filesystem's POV? (eg. it is
more a relevant item to memory management and possibly block layer).
OTOH if it is discussed in the context of "large blocks in the buffer
layer is crap because we can do it with higher order pagecache", then
that might be interesting :)

Anyway, I won't say no to any proposal, so keep the ideas coming. We
can talk about whatever we find interesting on the day.


>>- how to make complex API changes without having to fix most things
>>  yourself.
> 
> 
> More issues:

Thanks Christoph, sounds good.

-- 
SUSE Labs, Novell Inc.

