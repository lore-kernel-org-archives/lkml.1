Return-Path: <linux-kernel-owner+w=401wt.eu-S934005AbZLPPeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005AbZLPPeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932670AbZLPPeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:34:07 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:52959 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbZLPPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kt9ga14KDGZrYpRO4TLJvjtplckxFN193nCyKlDWKzVQmmMxIji0R9c5nAgb1kv6S6
         qOnDGv13xJiHLrXsCT9XFBmgMs742MudOs6ArdSQ77eonnlxORUqSqi6GDruLqg2rH7V
         KyRraa5tVMLPOg6SUakBJiJWenjKOR7tFjnVA=
Date: Wed, 16 Dec 2009 23:35:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Alex Chiang <achiang@hp.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Li, Haicheng" <haicheng.li@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm: introduce dump_page() and print symbolic flag names
Message-ID: <20091216153513.GC2804@hack>
References: <20091216122640.GA13817@localhost> <20091216123310.GA17522@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216123310.GA17522@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 08:33:10PM +0800, Wu Fengguang wrote:
>On Wed, Dec 16, 2009 at 08:26:40PM +0800, Wu Fengguang wrote:
>> - introduce dump_page() to print the page info for debugging some error condition.
>> - convert three mm users: bad_page(), print_bad_pte() and memory offline failure. 
>> - print an extra field: the symbolic names of page->flags
>> 
>> Example dump_page() output:
>> 
>> [  157.521694] page:ffffea0000a7cba8 count:2 mapcount:1
>> mapping:ffff88001c901791 index:147
>                                 ~~~ this is in fact 0x147
>
>The index value may sometimes be misread as decimal number, shall this
>be fixed by adding a "0x" prefix?


Using '%#x' will do.

Thanks.


>
>> [  157.525570] page flags: 100000000100068(uptodate|lru|active|swapbacked)
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
