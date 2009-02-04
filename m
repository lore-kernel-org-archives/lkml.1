Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZBDCv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZBDCv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZBDCvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:51:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45163 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZBDCvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:51:47 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v2] fix mlocked page counter mistmatch
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux mm <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090204024447.GB6212@barrios-desktop>
References: <20090204103648.ECAF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090204024447.GB6212@barrios-desktop>
Message-Id: <20090204115047.ECB5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed,  4 Feb 2009 11:51:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Could you please teach me why this issue doesn't happend on munlockall()?
> > your scenario seems to don't depend on exit_mmap().
> 
> 
> Good question.
> It's a different issue.
> It is related to mmap_sem locking issue. 
> 
> Actually, I am about to make a patch.
> But, I can't understand that Why try_do_mlock_page should downgrade mm_sem ?
> Is it necessary ? 
> 
> In munlockall path, mmap_sem already is holding in write-mode of mmap_sem.
> so, try_to_mlock_page always fail to downgrade mmap_sem.
> It's why it looks like working well about mlocked counter. 

lastest linus tree don't have downgrade mmap_sem.
(recently it was removed)

please see it.


