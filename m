Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbYFDN5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbYFDN5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYFDN44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:56:56 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53303 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYFDN44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:56:56 -0400
Date: Wed, 4 Jun 2008 16:56:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quota: Split out quota_struct.h out of quota.h
Message-ID: <20080604135624.GA13683@cs181133002.pp.htv.fi>
References: <12124266712214-git-send-email-jack@suse.cz> <12124266711334-git-send-email-jack@suse.cz> <12124266712838-git-send-email-jack@suse.cz> <12124266722979-git-send-email-jack@suse.cz> <12124266723968-git-send-email-jack@suse.cz> <12124266721420-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12124266721420-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 07:11:10PM +0200, Jan Kara wrote:
> Split some structure definitions from quota.h to quota_struct.h so that they
> can be separately included in fs.h. This makes it possible to declare some
> useful inline functions in quota.h because it can now include fs.h.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/fs.h       |    2 +-
>  include/linux/quota.h    |  193 +---------------------------------------------
>  include/linux/quotaops.h |    1 +
>  include/linux/syscalls.h |    2 +-
>  4 files changed, 5 insertions(+), 193 deletions(-)
>...

Missing "git-add include/linux/quota_struct.h" ?

> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -37,13 +37,11 @@
>  
>  #include <linux/errno.h>
>  #include <linux/types.h>
> +#include <linux/quota_struct.h>
>...

This breaks our userspace headers.

Please always run "make headers_check" after touching #include's
under include/

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

