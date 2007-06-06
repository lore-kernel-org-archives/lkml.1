Return-Path: <linux-kernel-owner+w=401wt.eu-S934777AbXFFQBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934777AbXFFQBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbXFFQB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:01:29 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:34132 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbXFFQB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:01:29 -0400
Message-ID: <4666DA55.5090405@fr.ibm.com>
Date: Wed, 06 Jun 2007 18:01:25 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org> <4666ABD4.8050402@fr.ibm.com> <4666D050.7010603@googlemail.com>
In-Reply-To: <4666D050.7010603@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Same problem here
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/console.log
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/mm-config2
> 
> 
> l *__page_check_anon_rmap+0x49
> 0xc1075ee5 is in __page_check_anon_rmap (mm/rmap.c:557).
> 552              * over the call to page_add_new_anon_rmap.
> 553              */
> 554             struct anon_vma *anon_vma = vma->anon_vma;
> 555             anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
> 556             BUG_ON(page->mapping != (struct address_space *)anon_vma);
> 557             BUG_ON(page->index != linear_page_index(vma, address));
> 558     #endif
> 559     }
> 560
> 561     /**
> 
> I'll try to revert
> mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch

yes, i gave it a try that but it seems that this patch is heavily 
interlaced with others. I assume Nick has a better understanding 
of the issue.

C.
