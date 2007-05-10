Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbXEJB47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbXEJB47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXEJB4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:56:52 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:43785 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753091AbXEJB4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:56:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=2eHc91tdWdWjjg/G8QQIv+q6mem0G1p3OKa7i4d70i6bhBEM1wMcqftfmQMJBzLJv05W7xrFwstkkF8e0eyat2qxVEeBUDc+4b53FYmYl4lnBse6DA3vAMs/rb69gai4oJ5wr5K9uB/UD1TdPz3slIsuckkKhMDhJ/hBkLg9Z94=  ;
Message-ID: <46427BDB.30004@yahoo.com.au>
Date: Thu, 10 May 2007 11:56:43 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705100928.34056.kernel@kolivas.org> <464261B5.6030809@yahoo.com.au> <200705101134.34350.kernel@kolivas.org>
In-Reply-To: <200705101134.34350.kernel@kolivas.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Thursday 10 May 2007 10:05, Nick Piggin wrote:

>>I'm not the gatekeeper and it is completely up to you whether you want
>>to work on something or not... but I'm sure you understand where I was
>>coming from when I suggested it doesn't get merged yet.
> 
> 
> No matter how you spin it, you're the gatekeeper.

If raising unaddressed issues means closing a gate, then OK. You can
equally open it by answering them.


>>You may not believe this, but I agree that swap prefetching (and
>>prefetching in general) has some potential to help desktop workloads :).
>>But it still should go through the normal process of being tested and
>>questioned and having a look at options for first improving existing
>>code in those problematic cases.
> 
> 
> Not this again? Proof was there ages ago that it helped and no proof that it 
> harmed could be found yet you cunningly pretend it never existed. It's been 
> done to death and I'm sick of this.

I said I know it can help. Do you know how many patches I have that help
some workloads but are not merged? That's just the way it works.

What I have seen is it helps the case where you force out a huge amount
of swap. OK, that's nice -- the base case obviously works.

You said it helped with the updatedb problem. That says we should look at
why it is going bad first, and for example improve use-once algorithms.
After we do that, then swap prefetching might still help, which is fine.


>>Once that process happens and it is shown to work nicely, etc., then I
>>would not be able to (or want to) keep it from getting merged.
>>
>>As far as cpusets goes... if your code goes in last, then you have to
>>make it work with what is there, as a rule. People are using cpusets
>>for memory resource control, which would have uses on a desktop system.
>>It is just a really bad precedent to set, having different parts of the
>>VM not work correctly together. Even if you made them mutually
>>exclusive CONFIG_ options, that is still not a very nice solution.
> 
> 
> That's as close to a 3 as I'm likely to get out of you.

If you're not willing to try making it work with existing code, among other
things, then yes it will be difficult to get it merged. That's not going to
change.

-- 
SUSE Labs, Novell Inc.
