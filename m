Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbZCPMzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbZCPMzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZCPMzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:55:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:62675 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbZCPMzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=veLwAd18L9xlwK1HGaEQVArNRVApWu/hX3tpk3JXjeKYXG5YrWyhGYixeG0gN6xWre
         CtD1ufjd3skzpRbDu0oS5sJ+QBKtm0BhmDYkRWS/9CMJ3SdYP3FWdXJvvnvncGurge0Q
         AKrKFjOyteS4hvCtXVoWlV8LYymj69C4iApCc=
MIME-Version: 1.0
In-Reply-To: <20090316211830.1FE8.A69D9226@jp.fujitsu.com>
References: <20090316105945.18131.82359.stgit@warthog.procyon.org.uk>
	 <20090316120224.GA16506@infradead.org>
	 <20090316211830.1FE8.A69D9226@jp.fujitsu.com>
Date: Mon, 16 Mar 2009 21:55:03 +0900
Message-ID: <28c262360903160555u402b4c34nf273951a207826a2@mail.gmail.com>
Subject: Re: [PATCH] Point the UNEVICTABLE_LRU config option at the 
	documentation
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
       lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size vmlinux
   text	   data	    bss	    dec	    hex	filename
6232681	 747665	 708608	7688954	 7552fa	vmlinux

size vmlinux.unevictable
   text	   data	    bss	    dec	    hex	filename
6239404	 747985	 708608	7695997	 756e7d	vmlinux.unevictable

It almost increases about 7K.
Many embedded guys always have a concern about size although it is very small.
It's important about embedded but may not be about server.

In addition, CONFIG_UNEVICTABLE_LRU feature don't have a big impact in
embedded machines which have a very small ram.
I guess many embedded guys will not use this feature.

So, I don't want to remove this configurable option.
Lets not add useless size bloat in embedded system.


On Mon, Mar 16, 2009 at 9:22 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Mon, Mar 16, 2009 at 10:59:45AM +0000, David Howells wrote:
>> > Point the UNEVICTABLE_LRU config option at the documentation describing the
>> > option.
>>
>> Didn't we decide a while ago that the option is pointless and the code
>> should always be enabled?
>
> Yeah.
> CONFIG_UNEVICTABLE_LRU lost existing reason by David's good patch recently.
>
> if nobody of nommu user post bug report in .30 age, I plan to remove
> this config option at .31 age.
>
> his patch is really really good job.
>
>
>
>



-- 
Kinds regards,
Minchan Kim
