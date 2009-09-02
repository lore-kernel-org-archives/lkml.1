Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZIBAKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZIBAKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 20:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZIBAKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 20:10:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38285 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbZIBAKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 20:10:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 2 Sep 2009 09:08:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       hannes@cmpxchg.org
Subject: Re: [mmotm][BUG] free is bigger than presnet Re: mmotm
 2009-08-27-16-51 uploaded
Message-Id: <20090902090816.c777f311.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090901191018.19a69696.kamezawa.hiroyu@jp.fujitsu.com>
References: <200908272355.n7RNtghC019990@imap1.linux-foundation.org>
	<20090901180032.55f7b8ca.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0909011031140.13740@sister.anvils>
	<20090901185013.c86bd937.kamezawa.hiroyu@jp.fujitsu.com>
	<20090901191018.19a69696.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009 19:10:18 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 1 Sep 2009 18:50:13 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Tue, 1 Sep 2009 10:33:31 +0100 (BST)
> > Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > 
> > > On Tue, 1 Sep 2009, KAMEZAWA Hiroyuki wrote:
> > > > 
> > > > I'm not digggin so much but /proc/meminfo corrupted.
> > > > 
> > > > [kamezawa@bluextal cgroup]$ cat /proc/meminfo
> > > > MemTotal:       24421124 kB
> > > > MemFree:        38314388 kB
> > > 
> > > If that's without my fix to shrink_active_list(), I'd try again with.
> > > Hugh
> > > 
> > Thank you very much. I missed this patch.
> > It's fixed.
> 
> Sorry again, at continuing tests...thre are still..
> 
> MemTotal:       24421124 kB
> MemFree:        25158956 kB
> Buffers:            2264 kB
> Cached:            34936 kB
> SwapCached:         5140 kB
> 
> I wonder I miss something..
> 
My mistake, sorry.

Thanks,
-Kame


> Thanks,
> -Kame
> 
> 

