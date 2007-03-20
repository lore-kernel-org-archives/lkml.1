Return-Path: <linux-kernel-owner+w=401wt.eu-S1030834AbXCTFeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030834AbXCTFeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 01:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030836AbXCTFeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 01:34:25 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:29467 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030834AbXCTFeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 01:34:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=MYOA47lruaDyRDa8t6CGS8gWbZwJTV+iRGQln8ckfupO52tsd5PvOOI9osCMcVwgRUzWqG/pgGABA8MVTdJkRP4Y3lxFo5SFQ7PRafI9sLTZG2fmDuuz7YD/z3C4x8UOOWsYyuw8aporSTHUJkOD57fs7JRNbHcKdLqUyJUvQzg=  ;
X-YMail-OSG: N_5o8BMVM1nKCckjChLMWS82rYNfxCZemRlHh0ckpGcXio66VIw4CgnyrT_4ZNiljfzflLaw81EavdwP7rsia0q9hjPuOoZueC8YqUg6nhanBwLDf09tNjXJOgRo0FFsJi_yZiX6PY4Y0kg-
Message-ID: <45FF7259.8090004@yahoo.com.au>
Date: Tue, 20 Mar 2007 16:34:17 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
References: <20070318233008.GA32597093@melbourne.sgi.com> <20070319092222.GA1720@infradead.org> <45FE61D3.90105@yahoo.com.au> <20070319122252.GA12029@infradead.org>
In-Reply-To: <20070319122252.GA12029@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Mar 19, 2007 at 09:11:31PM +1100, Nick Piggin wrote:
> 
>>I've got the patches in -mm now. I hope they will get merged when the
>>the next window opens.
>>
>>I didn't submit the ->page_mkwrite conversion yet, because I didn't
>>have any callers to look at. It is is slightly less trivial than for
>>nopage and nopfn, so having David's block_page_mkwrite is helpful.
> 
> 
> Yes.  I was just wondering whether it makes more sense to do this
> functionality directly ontop of ->fault instead of converting i over
> real soon.

I would personally prefer that, but I don't want to block David's
patch from being merged if the ->fault patches do not get in next
cycle. If the fault patches do make it in first, then yes we should
do the page_mkwrite conversion before merging David's patch.

I'll keep an eye on it, and try to do the right thing.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
