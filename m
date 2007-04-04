Return-Path: <linux-kernel-owner+w=401wt.eu-S966317AbXDDGux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966317AbXDDGux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966318AbXDDGuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:50:52 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:59237 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966317AbXDDGuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:50:51 -0400
Message-ID: <46134AA9.4080804@cosmosbay.com>
Date: Wed, 04 Apr 2007 08:50:17 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patches] threaded vma patches (was Re: missing madvise functionality)
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org> <4612DCC6.7000504@cosmosbay.com> <46130BC8.9050905@yahoo.com.au> <46133A8B.50203@cosmosbay.com> <46134124.2040705@yahoo.com.au> <461348CD.9000200@redhat.com>
In-Reply-To: <461348CD.9000200@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 04 Apr 2007 08:50:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> Nick Piggin wrote:
>> Sad. Although Ulrich did seem interested at one point I think? Ulrich,
>> do you agree at least with the interface that Eric is proposing?
> 
> I have no idea what you're talking about.
> 

You were CC on this one, you can find an archive here :

http://lkml.org/lkml/2007/3/15/230

This avoids mmap_sem for private futexes (PTHREAD_PROCESS_PRIVATE  semantic)

