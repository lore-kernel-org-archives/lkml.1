Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXDVVqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXDVVqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 17:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbXDVVqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 17:46:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54018 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXDVVqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 17:46:54 -0400
Date: Sun, 22 Apr 2007 23:46:33 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: 7eggert@gmx.de, Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wrong free clusters count on FAT32
In-Reply-To: <87wt04sdyb.fsf@duaron.myhome.or.jp>
Message-ID: <Pine.LNX.4.58.0704222342110.3424@be1.lrz>
References: <8bAF0-3Yj-29@gated-at.bofh.it> <8bDta-8rc-31@gated-at.bofh.it>
 <8bFEr-3B4-1@gated-at.bofh.it> <8cwz8-2fE-13@gated-at.bofh.it>
 <E1Hfc7X-00010D-09@be1.lrz> <87wt04sdyb.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19BHeYKy0VvvR0mvHHZSdvLwKwr0RIE38dEb0a
 2Cd6VgDXuifM+CCHcHbF+KS/gCElu5a3KbMAGwkauprGJJkzMW
 AAqujI9d3/ZYBgod9i2aw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007, OGAWA Hirofumi wrote:
> Bodo Eggert <7eggert@gmx.de> writes:

> > Windows _does_ care*, it will pretend the disk to be full.
> 
> Did you test on 2000 or XP? (e.g. write 0 to free_clusters, then
> create new file.)

That was back when I still used W98.

> > - usefree is a bad name (I'd suggest recalc_free instead),
> 
> Is it about nofree option?

Yes. I think recalc_free is way more descriptive.

> > and your description is too cryptic to be understood by a non-linux
> > FAT expert.
> 
> Um... why do we need to care about non-linux people in the patch?

Non-experts in Linux FAT implementation details. "recalc sounds like might 
take long, let's try to disable it" should be all it takes to get a fast 
mount.
-- 
Top 100 things you don't want the sysadmin to say:
35. Ummm... Didn't you say you turned it off?
