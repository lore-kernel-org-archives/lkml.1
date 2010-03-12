Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab0CLNDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:03:15 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64611 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab0CLNDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:03:14 -0500
MIME-Version: 1.0
In-Reply-To: <87aaud22jj.fsf@macbook.be.48ers.dk>
References: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk> 
	<4B9A2548.7050401@msgid.tls.msk.ru> <87aaud22jj.fsf@macbook.be.48ers.dk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 12 Mar 2010 14:02:57 +0100
Message-ID: <ac3eb2511003120502y2953ff0au81ee5c4d76261a87@mail.gmail.com>
Subject: Re: [PATCH] devtmpfs: support !CONFIG_TMPFS
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Michael Tokarev <mjt@tls.msk.ru>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 12:38, Peter Korsgaard <jacmet@sunsite.dk> wrote:
>>>>>> "Michael" == Michael Tokarev <mjt@tls.msk.ru> writes:
>  >> +#ifdef CONFIG_TMPFS
>  >> return get_sb_single(fs_type, flags, data, shmem_fill_super, mnt);
>  >> +#else
>  >> +   return get_sb_single(fs_type, flags, data, ramfs_fill_super, mnt);
>  >> +#endif
>  >> }
>
>  Michael> May be completely not to the point or even wrong, but I were
>  Michael> starring at this change for quite some time trying to understand
>  Michael> what's the difference.  Can we do it like this:
>
>  Michael> #ifdef CONFIG_TMPFS
>  Michael> # define devtmpfs_fill_super shmem_fill_super
>  Michael> #else
>  Michael> # define devtmpfs_fill_super ramfs_fill_super
>  Michael> #endif
>  Michael>       return get_sb_single(fs_type, flags, data, devtmpfs_fill_super, mnt);

> Sure, if people find that cleaner - Kay?

For the style:
  I would prefer your original version.

For the patch:
  Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Thanks,
Kay
