Return-Path: <linux-kernel-owner+w=401wt.eu-S966205AbXDCRhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966205AbXDCRhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966207AbXDCRhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:37:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966203AbXDCRhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:37:31 -0400
Message-ID: <461290D5.3020200@redhat.com>
Date: Tue, 03 Apr 2007 13:37:25 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <46128708.9030900@redhat.com> <46128A77.4080008@redhat.com>
In-Reply-To: <46128A77.4080008@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Rik van Riel wrote:
>> I already started looking into implementing this.
>>
>> Basically:
>> [...]
> 
> Sounds good.  Except:
> 
> 
>> 1) on MADV_DONTNEED, mark pages clean, not accessed and move them
>>    to some "dontneed" LRU list.
> 
> LRU is likely the wrong answer.  The longer a page has not been reused
> the more likely it won't be.  So, the dontneed-list  should be a simple
> FIFO.

Well yes, it is.

If the page was accessed again, it will be moved to
the active list :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
