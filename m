Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYJGV37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYJGV37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYJGV3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:29:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbYJGV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:29:48 -0400
Message-ID: <48EBD469.6090409@redhat.com>
Date: Tue, 07 Oct 2008 17:28:09 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Lee.Schermerhorn@hp.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no, dlezcano@fr.ibm.com,
       penberg@cs.helsinki.fi, neilb@suse.de, davem@davemloft.net
Subject: Re: split-lru performance mesurement part2
References: <20081003153810.5dd0a33e@bree.surriel.com>	<20081004232549.CE53.KOSAKI.MOTOHIRO@jp.fujitsu.com>	<20081007231851.3B88.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081007131719.8bb24698.akpm@linux-foundation.org>
In-Reply-To: <20081007131719.8bb24698.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> dbench is pretty chaotic and it could be that a good change causes
> dbench to get worse.  That's happened plenty of times in the past.
> 
> 
>> Do you have any suggestion?
> 
> 
> One of these:
> 
> vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
> vm-dont-run-touch_buffer-during-buffercache-lookups.patch
> 
> perhaps?

Worth a try, but it could just as well be a CPU scheduler change
that happens to indirectly impact locking :)

-- 
All rights reversed.
