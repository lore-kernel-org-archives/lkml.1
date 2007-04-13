Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXDMHFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXDMHFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXDMHFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:05:54 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:30419 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752264AbXDMHFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:05:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=z/Xdh4TY2DlrCG92LMG32fzTq+6tyKYodO+z5vdIE5j4xhzZDR5dgtB8I+9V5HRKljWgClmH+HXnVNUfaaef1IIF3JaUAHRKkW6/mDP0QAdzeI0yExE5RRcZo+SftCJ05PK33DXvUQmfdMOYfm6JGUL2ci1Ac583ruv9ohqJryM=  ;
X-YMail-OSG: NaKh_F8VM1ked2PUd8Ay_BhI3V30cpvGyT7QZU3Uo7s8uz7kHIggfzcVFz26JKS44hz8.a1tuQ--
Message-ID: <461F2BCB.2020200@yahoo.com.au>
Date: Fri, 13 Apr 2007 17:05:47 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com>
In-Reply-To: <20070413065357.GP2986@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> Andrew Morton wrote:
> 
>>>Then you just end up with the same thing, don't you?
> 
> 
> On Fri, Apr 13, 2007 at 12:50:20PM +1000, Nick Piggin wrote:
> 
>>Well _you_ do, because that happens to be exactly what you want. Bill
>>ends up with something that displays page_mapcount instead. And I
>>end up with something that traverses LRU lists rather than pfns. And
>>none of it goes in /proc/ or linux-2.6/.
>>So it isn't really the same thing at all.
> 
> 
> The EM guys aren't dealing with the database; they're dealing with some
> enterprise management thingie that does things like control how many
> client connections are allowed for each database instance. Unless
> they're doing less than I expect, and are largely something like procps
> on steroids and enterprise silliness.

Ah, OK. Anyway, with kprobes/systemtap they can do whatever they like
and none of us need to care in the slightest ;)

-- 
SUSE Labs, Novell Inc.
