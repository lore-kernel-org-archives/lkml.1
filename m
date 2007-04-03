Return-Path: <linux-kernel-owner+w=401wt.eu-S1945966AbXDCV3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945966AbXDCV3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945975AbXDCV3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:29:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945966AbXDCV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:29:48 -0400
Message-ID: <4612C722.1000006@redhat.com>
Date: Tue, 03 Apr 2007 17:29:06 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com> <20070403135154.61e1b5f3.akpm@linux-foundation.org> <4612C059.8070702@redhat.com> <4612C2B6.3010302@cosmosbay.com> <4612C5AC.2070008@goop.org>
In-Reply-To: <4612C5AC.2070008@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Eric Dumazet wrote:
>> mmap()/brk() must give fresh NULL pages, but maybe
>> madvise(MADV_DONTNEED) can relax this requirement (if the pages were
>> reclaimed, then a page fault could bring a new page with random content) 
> 
> Only if those pages were originally from that process.  Otherwise you've
> got a bit of an information leak there.

Or from another process by the same user, in the same security
context.  That gets a bit more complex though :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
