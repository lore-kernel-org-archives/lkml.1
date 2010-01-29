Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870Ab0A2QZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0A2QZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695Ab0A2QZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:25:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53449 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab0A2QZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:25:46 -0500
Message-ID: <c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20100129162137.79b2a6d4@lxorguk.ukuu.org.uk>
References: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com>
    <20100129162137.79b2a6d4@lxorguk.ukuu.org.uk>
Date: Sat, 30 Jan 2010 01:25:43 +0900 (JST)
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       vedran.furac@gmail.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> panic_on_oom=1 works enough well.For Vedran's, overcommit memory will
>> work
>> well. But oom-killer kills very bad process if not tweaked.
>> So, I think some improvement should be done.
>
> That is why we have the per process oom_adj values - because for nearly
> fifteen years someone comes along and says "actually in my environment
> the right choice is ..."
>
> Ultimately it is policy. The kernel simply can't read minds.
>
If so, all heuristics other than vm_size should be purged, I think.
...Or victim should be just determined by the class of application
user sets. oom_adj other than OOM_DISABLE, searching victim process
by black magic are all garbage.

Thanks,
-Kame

