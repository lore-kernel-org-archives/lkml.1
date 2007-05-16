Return-Path: <linux-kernel-owner+w=401wt.eu-S1760534AbXEPSAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760534AbXEPSAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbXEPSAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:00:00 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:45246 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756415AbXEPR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:59:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=toeCxRV5XFWTJgJPEpPRWWYwHvYvHgQBwzLFEfU+JAbYedsrtaWkQmq+2KJTTTQnoIQaJtdyOUYbO3OZv5p+y3ZCf+KvFnQdjs7cA4g/5hNMErDVR85QQzgjyBeZY/bnUzArWNq0fESY4mH2VzsFYfiZnHMkN74yGiJr9T8UZZ0=  ;
X-YMail-OSG: hahTAhwVM1n2VT9oHmXeWCRefQlcL70IB8pZ1t0J7iKwjf8VIBBMaliRrKmvS3EHYqQnf7wRVA--
Message-ID: <464B4699.3090803@yahoo.com.au>
Date: Thu, 17 May 2007 03:59:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
References: <464B3F2D.9030603@yahoo.com.au> <464B3209.4010003@yahoo.com.au> <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com> <23262.1179334587@redhat.com> <24100.1179337608@redhat.com>
In-Reply-To: <24100.1179337608@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So did we just get your issues sorted? I _think_ *snip* is the
Howells code for "OK", but I can never be sure ;)

FWIW, as a rule, ClearPageUptodate should never be done by anyone,
least of all a filesystem on regular file pagecache. I need to go
through and audit this stuff... but so much backlog :P

David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>>How do you do a write-through cache for shared-writable mmap?
>>
>>For shared writable mmap? I don't know...

Anyway, *snip* the side discussion.

-- 
SUSE Labs, Novell Inc.
