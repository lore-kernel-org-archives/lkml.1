Return-Path: <linux-kernel-owner+w=401wt.eu-S1751501AbXBNBdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbXBNBdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbXBNBdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:33:46 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:46034 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751501AbXBNBdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:33:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=yf+TDkfWirPsgVP0yVise9Z5yLYKwUbM8eJm099QuH+M92Bnfmp4kFSMckvV/e44vjF3pKFliOeYS5+/x+F66diYFXEBa22pR9Dn7dbHgOUQmJPgoiCz8OIvzlNtmxmqleGglA6Fib3/jwuU0sYtd1EbpPKrNsRniN3vlYuduX8=  ;
X-YMail-OSG: kgAhyXkVM1kEa8gDR50D.P5Hg02uQdQz9jWtLfGFrHrrfJMPhchq_56EEohn.HD6QkMqL_LdyvvjoYzbwC2KY0IoTb6VKCKf1.cuAW4i0rXmU22xQxdA3nLVmJ0GW324PdW2z7Mfsun0B7k-
Message-ID: <45D266E3.4050905@yahoo.com.au>
Date: Wed, 14 Feb 2007 12:33:23 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, tony.luck@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch] build error: allnoconfig fails on mincore/swapper_space
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com> <20070212150802.f240e94f.akpm@linux-foundation.org> <45D12715.4070408@yahoo.com.au> <20070213121217.0f4e9f3a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702132224280.3729@blonde.wat.veritas.com> <20070213144909.70943de2.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702140009320.21315@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0702140009320.21315@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 13 Feb 2007, Randy Dunlap wrote:
> 
>>From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>>Don't check for pte swap entries when CONFIG_SWAP=n.
>>And save 'present' in the vec array.
>>
>>mm/built-in.o: In function `sys_mincore':
>>(.text+0xe584): undefined reference to `swapper_space'
>>
>>Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> 
> What you've done there is fine, Randy, thank you.

Can't you have migration without swap?

> But I just got out of bed to take another look, and indeed:
> what is it doing in the none_mapped !vma->vm_file case?
> passing back an uninitialized vector.

I must have completely forgotten about the vector :(

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
