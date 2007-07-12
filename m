Return-Path: <linux-kernel-owner+w=401wt.eu-S935695AbXGLCm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935695AbXGLCm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbXGLCmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:42:40 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:35707 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933076AbXGLCmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:42:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ZcdnMMpEKBbWB7B9u35LYVjMZI9Fyoaoec/pj43ArzhtFdhukE7Hl1OzqYeMYclL4vd44BYMq3GbIctfpZIFdynjMwC+mIKmu3sD5WxVrlFmUPdxxr2P/GAoVQ7Di5BGd26AHDXdR/G+UzZa8BrtBTIT3+umQT4PQjre0GswwrA=  ;
X-YMail-OSG: VNE5h5AVM1kC5HbKk4HHbto1ymSUS_yrKDWASHkGjrkZhNJdNpo8x.HEhUrF3xJUrOGqcJik45WMD3mMq5WmGkuOy_c30EkOjBu3Horvkjww24H4j2c-
Message-ID: <46959516.30007@yahoo.com.au>
Date: Thu, 12 Jul 2007 12:42:30 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       xfs-oss <xfs@oss.sgi.com>
Subject: Re: block_page_mkwrite? (Re: fault vs invalidate race (Re: -mm merge
 plans for 2.6.23))
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <46957BE1.1010104@yahoo.com.au> <20070712023100.GX12413810@sgi.com>
In-Reply-To: <20070712023100.GX12413810@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Thu, Jul 12, 2007 at 10:54:57AM +1000, Nick Piggin wrote:
> 
>>Andrew Morton wrote:
>>
>>>The fault-vs-invalidate race fix.  I have belatedly learned that these 
>>>need
>>>more work, so their state is uncertain.
>>
>>The more work may turn out being too much for you (although it is nothing
>>exactly tricky that would introduce subtle bugs, it is a fair amont of 
>>churn).
> 
> 
> OK, so does that mean we can finally get the block_page_mkwrite
> patches merged?
> 
> i.e.:
> 
> http://marc.info/?l=linux-kernel&m=117426058311032&w=2
> http://marc.info/?l=linux-kernel&m=117426070111136&w=2
> 
> I've got up-to-date versions of them ready to go and they've been
> consistently tested thanks to the XFSQA test I wrote for the bug
> that it fixes. I've been holding them out-of-tree for months now
> because ->fault was supposed to supercede this interface.....

Yeah, as I've said, don't hold them back because of me. They are
relatively simple enough that I don't see why they couldn't be
merged in this window.

-- 
SUSE Labs, Novell Inc.
