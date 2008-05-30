Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYE3B4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYE3B4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYE3B4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:56:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:52639 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYE3B4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dFuIMnvQKpj2AFuN+rH2HFdwBfCMEo0WhQGlOYUrNDYyqjP5wgZFoXX5U86dX3XP1hxUYyTxsOpdUMo4+yRviDbzFtOy461YPSX2qwAq7LX9f0V6uwDBca9HkchJ2zl8vK8py9980NxpF/margYhn6KiX0oxGB4ji7BudWhNJLk=
Message-ID: <28c262360805291856t4dfc226fwbede35778ea528bc@mail.gmail.com>
Date: Fri, 30 May 2008 10:56:35 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH 00/25] Vm Pageout Scalability Improvements (V8) - continued
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       eric.whitney@hp.com, linux-mm@kvack.org, npiggin@suse.de
In-Reply-To: <20080529162029.7b942a97@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080529195030.27159.66161.sendpatchset@lts-notebook>
	 <20080529131624.60772eb6.akpm@linux-foundation.org>
	 <20080529162029.7b942a97@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 5:20 AM, Rik van Riel <riel@redhat.com> wrote:
> On Thu, 29 May 2008 13:16:24 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> I was >this< close to getting onto Rik's patches (honest) but a few
>> other people have been kicking the tyres and seem to have caused some
>> punctures so I'm expecting V9?
>
> If I send you a V9 up to patch 12, you can apply Lee's patches
> straight over my V9 :)
>

I failed to patch Lee's patches over your V9.

barrios@barrios-desktop:~/linux-2.6$ patch -p1 < /tmp/msg0_13.txt
patching file mm/Kconfig
patching file include/linux/page-flags.h
patching file include/linux/mmzone.h
patching file mm/page_alloc.c
patching file include/linux/mm_inline.h
patching file include/linux/swap.h
patching file include/linux/pagevec.h
patching file mm/swap.c
patching file mm/migrate.c
patching file mm/vmscan.c
Hunk #10 FAILED at 1162.
Hunk #11 succeeded at 1210 (offset 3 lines).
Hunk #12 succeeded at 1242 (offset 3 lines).
Hunk #13 succeeded at 1380 (offset 3 lines).
Hunk #14 succeeded at 1411 (offset 3 lines).
Hunk #15 succeeded at 1962 (offset 3 lines).
Hunk #16 succeeded at 2300 (offset 3 lines).
1 out of 16 hunks FAILED -- saving rejects to file mm/vmscan.c.rej
patching file mm/mempolicy.c
patching file mm/internal.h
patching file mm/memcontrol.c
patching file include/linux/memcontrol.h

-- 
Kinds regards,
MinChan Kim
