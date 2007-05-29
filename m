Return-Path: <linux-kernel-owner+w=401wt.eu-S1763727AbXE2FKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763727AbXE2FKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 01:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXE2FK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 01:10:29 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:47867 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753277AbXE2FK2 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 01:10:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=C9WZNj5Zv3KIqFOSCgGdny33hFwvgkQCxMNiJ0R4gSaxsnacWv8kcidz/RUAnd2chDbkN627J8v6Pw7jZua1yjZSwhvQa4q93zeM5s0yDWu67se4wrb8vYxWP2DNedaTSyQ2TfCWAxtug7ksBBhqdIbLc49A2KL1Mhv4cyo5+dQ=  ;
X-YMail-OSG: wE0DcXsVM1mTNN0gEq.tGVRqHDjjPrlOzBywd8xKRB9mWab2Xmy0ZQv95tjaGDyYmwjvuaobjQ--
Message-ID: <465BB5BA.3050900@yahoo.com.au>
Date: Tue, 29 May 2007 15:10:18 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: carsteno@de.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com>
In-Reply-To: <4653F264.1030807@de.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Otte wrote:

> The current xip stack relies on having struct page behind the memory 
> segment. This causes few impact on memory management, but occupies some 
> more memory. The cramfs patch chose to modify copy on write in order to 
> deal with vmas that don't have struct page behind.
> So far, Hugh and Linus have shown strong opposition against copy on 
> write with no struct page behind. If this implementation is acceptable 
> to the them, it seems preferable to me over wasting memory. The xip 
> stack should be modified to use this vma flag in that case.

I would rather not :P

We can copy on write without a struct page behind the source today, no?
What is insufficient for the XIP code with the current COW?

-- 
SUSE Labs, Novell Inc.
