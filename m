Return-Path: <linux-kernel-owner+w=401wt.eu-S1030905AbXDVOxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030905AbXDVOxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030935AbXDVOxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:53:51 -0400
Received: from ns1.suse.de ([195.135.220.2]:51145 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030905AbXDVOxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:53:50 -0400
From: Andreas Schwab <schwab@suse.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: 7eggert@gmx.de, Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wrong free clusters count on FAT32
References: <8bAF0-3Yj-29@gated-at.bofh.it> <8bDta-8rc-31@gated-at.bofh.it>
	<8bFEr-3B4-1@gated-at.bofh.it> <8cwz8-2fE-13@gated-at.bofh.it>
	<E1Hfc7X-00010D-09@be1.lrz> <87wt04sdyb.fsf@duaron.myhome.or.jp>
	<877is4scre.fsf@duaron.myhome.or.jp>
X-Yow: Is this ANYWHERE, USA?
Date: Sun, 22 Apr 2007 16:53:32 +0200
In-Reply-To: <877is4scre.fsf@duaron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Sun, 22 Apr 2007 23:29:57 +0900")
Message-ID: <jewt04e9zn.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> diff -puN Documentation/filesystems/vfat.txt~fat_dont-use_free_clusters-for-fat32 Documentation/filesystems/vfat.txt
> --- linux-2.6/Documentation/filesystems/vfat.txt~fat_dont-use_free_clusters-for-fat32	2007-04-22 23:06:21.000000000 +0900
> +++ linux-2.6-hirofumi/Documentation/filesystems/vfat.txt	2007-04-22 23:28:19.000000000 +0900
> @@ -34,6 +34,13 @@ iocharset=name -- Character set to use f
>  		 NOTE: "iocharset=utf8" is not recommended. If unsure,
>  		 you should consider the following option instead.

"the following option" is no longer correct.

>  
> +usefree       -- Use the "free clusters" value stored on FSINFO. It'll
> +                 be used to determine number of free clusters without
> +                 scanning disk. But it's not used by default, because
> +                 recent Windows don't update it correctly in some
> +                 case. If you are sure the "free clusters" on FSINFO is
> +                 correct, by this option you can avoid scanning disk.
> +
>  utf8=<bool>   -- UTF-8 is the filesystem safe version of Unicode that
>  		 is used by the console.  It can be enabled for the
>  		 filesystem with this option. If 'uni_xlate' gets set,

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
