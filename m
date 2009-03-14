Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZCNAzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZCNAzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZCNA1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:27:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:49998 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091AbZCNA1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aQ/XjTqDrgZU5Qfu6jNbq6AAU2qHrSB0mhzwteRlaS8gsEXblMdg0Jz+HnB6Z3pmDd
         eRg5b/xRs/L+Y4mJJl7WkBhhomNJIyJashoo85IM/0r1uO4DGGnz5UJ4S8fkNTiouBMS
         uxNHw6zyzPvdrL2aorzClJHb31I+fVIJOJj6s=
MIME-Version: 1.0
In-Reply-To: <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
References: <20090312100049.43A3.A69D9226@jp.fujitsu.com>
	 <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
Date: Sat, 14 Mar 2009 09:27:43 +0900
Message-ID: <28c262360903131727l4ef41db5xf917c7c5eb4825a8@mail.gmail.com>
Subject: Re: [PATCH 0/2] Make the Unevictable LRU available on NOMMU
From: Minchan Kim <minchan.kim@gmail.com>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       peterz@infradead.org, nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
       riel@surriel.com, lee.schermerhorn@hp.com,
       Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David.

It seems your patch is better than mine.  Thanks. :)
But my concern is that as Peter pointed out, unevictable lru's
solution is not fundamental one.

He want to remove ramfs page from lru list to begin with.
I guess Andrew also thought same thing with Peter.

I think it's a fundamental solution. but it may be long term solution.
This patch can solve NOMMU problem in current status.

Andrew, What do you think about it ?

On Sat, Mar 14, 2009 at 2:33 AM, David Howells <dhowells@redhat.com> wrote:
>
> The first patch causes the mlock() bits added by CONFIG_UNEVICTABLE_LRU to be
> unavailable in NOMMU mode.
>
> The second patch makes CONFIG_UNEVICTABLE_LRU available in NOMMU mode.
>
> David
>



-- 
Kinds regards,
Minchan Kim
