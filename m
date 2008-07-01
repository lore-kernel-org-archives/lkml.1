Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYGABH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYGABH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbYGABHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:07:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46235 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbYGABHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:07:20 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <9156032.1214874373850.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 1 Jul 2008 10:06:13 +0900 (JST)
To: kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: Re: Re: [RFC][PATCH] memcg: change shmem handler.
Cc: Hugh Dickins <hugh@veritas.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <25019527.1214873805265.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <25019527.1214873805265.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0806302024050.27080@blonde.site>
 <Pine.LNX.4.64.0806290117510.21758@blonde.site>
 <Pine.LNX.4.64.0806290120270.21758@blonde.site>
 <20080630173631.a252bb0e.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
Sorry..a bit more words.
>>Is that a good thing?  If we really decide that globally we
>>need such a counter, then fine for memcg to follow; but I've
>>not yet heard it asked for.
>After swap-controller is introduced, I can imagine there will be a
>swap-full/swap-less cgroup. And shmem will be able to be swapped out.
                                          not
>memcg handles limit of memory usage and Admin/Middleware will want to
>know current limit is good or bad. So, showing amount of tmpfs 
>will be good (It's now shown as Cache...a pages easily kicked out ;)
>
I'm not sure but how this seems under memcg in which DataBase runs.

Now.
   - anon
   - cache (including DataBase's shmem)
After
   - anon
   - cache (file cache)
   - shmem (DataBase's working area)

not good ?

Thanks,
-Kame
