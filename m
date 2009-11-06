Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbZKFTUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbZKFTUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbZKFTUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:20:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56252 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbZKFTUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:20:50 -0500
Message-ID: <ffef0f18fe9ae9948d0db7fb4b0a0341.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911061409310.15636@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
    <20091104234923.GA25306@redhat.com>
    <alpine.DEB.1.10.0911051004360.25718@V090114053VZO-1>
    <alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1>
    <20091106101106.8115e0f1.kamezawa.hiroyu@jp.fujitsu.com>
    <20091106122344.51118116.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.1.10.0911061231580.5187@V090114053VZO-1>
    <da621335371fccd6cfb3d8d7c0c2bf3a.squirrel@webmail-b.css.fujitsu.com>
    <alpine.DEB.1.10.0911061409310.15636@V090114053VZO-1>
Date: Sat, 7 Nov 2009 04:20:51 +0900 (JST)
Subject: Re: [MM] Make mm counters per cpu instead of atomic V2
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Dave Jones" <davej@redhat.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Sat, 7 Nov 2009, KAMEZAWA Hiroyuki wrote:
>
>> And allocate mm->usage only when the first CLONE_THREAD is specified.
>
> Ok.
>
>> if (mm->usage)
>>     access per cpu
>> else
>>     atomic_long_xxx
>
> If we just have one thread: Do we need atomic access at all?
>
Unfortunately, kswapd/vmscan touch this.

Thanks,
-Kame


