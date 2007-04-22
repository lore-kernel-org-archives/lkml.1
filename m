Return-Path: <linux-kernel-owner+w=401wt.eu-S1030871AbXDVUJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030871AbXDVUJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 16:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030882AbXDVUJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 16:09:36 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:65292 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030871AbXDVUJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 16:09:35 -0400
Date: Sun, 22 Apr 2007 22:11:15 +0200
From: DervishD <lkml@dervishd.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wrong free clusters count on FAT32
Message-ID: <20070422201115.GD12748@DervishD>
Mail-Followup-To: Bodo Eggert <7eggert@gmx.de>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Juergen Beisert <juergen127@kreuzholzen.de>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <8bAF0-3Yj-29@gated-at.bofh.it> <8bDta-8rc-31@gated-at.bofh.it> <8bFEr-3B4-1@gated-at.bofh.it> <8cwz8-2fE-13@gated-at.bofh.it> <E1Hfc7X-00010D-09@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1Hfc7X-00010D-09@be1.lrz>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Bodo :)

 * Bodo Eggert <7eggert@gmx.de> dixit:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
> >>  * Juergen Beisert <juergen127@kreuzholzen.de> dixit:
> 
> >>> So the last free sector count is also stored. When mounting this
> >>> filesystem you don't need to walk through the whole FAT to calculate
> >>> the available space, you can use this "cached" value instead. And this
> >>> cached value seems not to be updated in your portable device.
> >>
> >>     It doesn't, certainly, but Windows doesn't care. Moreover, the
> >> device doesn't seem to recalculate the value on every run (unless it
> >> does it lightning fast!), so maybe the number is stored elsewhere (the
> >> count can be stored in many places as far as I've read, but I don't know
> >> the details).
> 
> AFAIR it's stored twice on FAT32, once in a backup sector and once in the
> superblock or extended superblock (don't remember, I think it was the
> extended ~). It's not stored on FAT{12,16}.

    I hadn't noticed the same problem with FAT16 pendrives, so I
suspected that. Thanks for confirming :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
