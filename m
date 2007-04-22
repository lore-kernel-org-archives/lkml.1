Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbXDVOEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbXDVOEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030879AbXDVOEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:04:20 -0400
Received: from mail.parknet.jp ([210.171.160.80]:3965 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbXDVOEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:04:20 -0400
X-AuthUser: hirofumi@parknet.jp
To: 7eggert@gmx.de
Cc: Juergen Beisert <juergen127@kreuzholzen.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wrong free clusters count on FAT32
References: <8bAF0-3Yj-29@gated-at.bofh.it> <8bDta-8rc-31@gated-at.bofh.it>
	<8bFEr-3B4-1@gated-at.bofh.it> <8cwz8-2fE-13@gated-at.bofh.it>
	<E1Hfc7X-00010D-09@be1.lrz>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Sun, 22 Apr 2007 23:04:12 +0900
In-Reply-To: <E1Hfc7X-00010D-09@be1.lrz> (Bodo Eggert's message of "Sun\, 22 Apr 2007 15\:28\:50 +0200")
Message-ID: <87wt04sdyb.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:

> Windows _does_ care*, it will pretend the disk to be full.

Did you test on 2000 or XP? (e.g. write 0 to free_clusters, then
create new file.)

> - usefree is a bad name (I'd suggest recalc_free instead),

Is it about nofree option?

> and your description is too cryptic to be understood by a non-linux
> FAT expert.

Um... why do we need to care about non-linux people in the patch?
Anyway, if you correct it, I'll update it gladly.

> - You forgot to update Documentation/

Sure. If you can post the patch, it'll be great.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
