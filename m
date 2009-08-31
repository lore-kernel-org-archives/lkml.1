Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZHaMON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZHaMON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZHaMON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:14:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43992 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZHaMOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:14:12 -0400
Message-ID: <48d928bed22f20fc495e9ca1758dc7ed.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090831121008.GL4770@balbir.in.ibm.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com>
    <20090831110204.GG4770@balbir.in.ibm.com>
    <119e8331d1210b1f56d0f6416863bfbc.squirrel@webmail-b.css.fujitsu.com>
    <20090831121008.GL4770@balbir.in.ibm.com>
Date: Mon, 31 Aug 2009 21:14:10 +0900 (JST)
Subject: Re: [RFC][PATCH 2/5] memcg: uncharge in batched manner
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
>> > Does this effect deleting of a group and delay it by a large amount?
>> >
>> plz see what cgroup_release_and_xxxx  fixed. This is not for delay
>> but for race-condition, which makes rmdir sleep permanently.
>>
>
> I've seen those patches, where rmdir() can hang. My conern was time
> elapsed since we do css_get() and do a cgroup_release_and_wake_rmdir()
>
plz read unmap() and truncate() code.
The number of pages handled without cond_resched() is limited.

Thanks,
-Kame


