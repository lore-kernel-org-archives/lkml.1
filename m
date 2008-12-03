Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYLCQPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYLCQPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYLCQPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:15:40 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39957 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYLCQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:15:39 -0500
Message-ID: <17466.10.75.179.62.1228320932.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20081203141931.GH17701@balbir.in.ibm.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
    <20081201211905.1CEB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
    <20081202180525.2023892c.kamezawa.hiroyu@jp.fujitsu.com>
    <20081203141931.GH17701@balbir.in.ibm.com>
Date: Thu, 4 Dec 2008 01:15:32 +0900 (JST)
Subject: Re: [PATCH 11/11] memcg: show reclaim_stat
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "LKML" <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh said:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-12-02
> 18:05:25]:
>
>> On Mon,  1 Dec 2008 21:19:49 +0900 (JST)
>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>> > added following four field to memory.stat file.
>> >
>> >   - recent_rotated_anon
>> >   - recent_rotated_file
>> >   - recent_scanned_anon
>> >   - recent_scanned_file
>> >
>> > it is useful for memcg reclaim debugging.
>> >
>> I'll put this under CONFIG_DEBUG_VM.
>>
>
> I think they'll be useful even outside for tasks that need to take
> decisions, it will be nice to see what sort of reclaim is going on.
There are already pgin/pgout value.

> I
> would like to see them outside, there is no cost associated with them
> and assuming we'll not change the LRU logic very frequently, we don't
> need to be afraid of breaking ABI either :)
>
There are 2 reasons to put this under DEBUG
 1. This is not exported as this value under /proc by global VM management.
 2. Few people can explain what this really means. No documentation in
    Docunemtation/ directory. I can't add precise explanation by myself.
    As Kosaki wrote, this is for his debug, IMHO.

If you want to show this, please add above two first.

Thanks,
-Kame







