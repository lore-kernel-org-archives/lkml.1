Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbZCLCMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbZCLCMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZCLCL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:11:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:37826 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbZCLCLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m34diwuh+XqSB2ChbzuYyP0wM1w2q8CAFK28c4xAp4u+rsaiPRKA/gsPZc60FFHLxr
         /SAzY6lESeuWUox4gvS0qVD0WlcxXqai60NGAYJ2t8vF+CfnRSKuNw3cvhTsOBxUzXln
         2zyvqKLv1H0Sj2wm8QlEsdK1jlAlI/gpFOmH0=
MIME-Version: 1.0
In-Reply-To: <20090312105622.43A6.A69D9226@jp.fujitsu.com>
References: <20090312100049.43A3.A69D9226@jp.fujitsu.com>
	 <20090312105226.88df3f63.minchan.kim@barrios-desktop>
	 <20090312105622.43A6.A69D9226@jp.fujitsu.com>
Date: Thu, 12 Mar 2009 11:11:53 +0900
Message-ID: <28c262360903111911l4e14685emb0261fe649bc03fa@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may 
	get wrongly discarded
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dhowells@redhat.com,
       torvalds@linux-foundation.org, peterz@infradead.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 11:00 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hi, Kosaki-san.
>>
>> I think ramfs pages's unevictablility should not depend on CONFIG_UNEVICTABLE_LRU.
>> It would be better to remove dependency of CONFIG_UNEVICTABLE_LRU ?
>>
>> How about this ?
>> It's just RFC. It's not tested.
>>
>> That's because we can't reclaim that pages regardless of whether there is unevictable list or not
>
> maybe, your patch work.
>
> but we can remove CONFIG_UNEVICTABLE_LRU build option itself completely
> after nommu folks confirmed CONFIG_UNEVICTABLE_LRU works well on their machine
>
> it is more cleaner IMHO.
> What do you think?
>
>

I agree your opinion, totally
Let us wait nommu folks's comments.


-- 
Kinds regards,
Minchan Kim
