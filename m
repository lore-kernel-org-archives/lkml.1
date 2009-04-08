Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbZDHVdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbZDHVdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765443AbZDHVcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:32:52 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:51462 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765209AbZDHVcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:32:50 -0400
Date: Wed, 8 Apr 2009 14:32:40 -0700
From: Martin Michlmayr <tbm@cyrius.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, rathamahata@php4.ru,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] befs: fix build on parisc
Message-ID: <20090408213240.GA12401@deprecation.cyrius.com>
References: <a4423d670904010632h35a20b8er8003578b5075189d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670904010632h35a20b8er8003578b5075189d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Beregalov <a.beregalov@gmail.com> [2009-04-01 17:32]:
> Fix this build error on parisc:
> fs/befs/super.c:85: error: 'PAGE_SIZE' undeclared

Same on ARM and MIPS, and your patch fixes it.  I hope this will go in
soon.

Tested-by: Martin Michlmayr <tbm@cyrius.com>

> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  fs/befs/super.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/befs/super.c b/fs/befs/super.c
> index 41f2b4d..ca40f82 100644
> --- a/fs/befs/super.c
> +++ b/fs/befs/super.c
> @@ -8,6 +8,7 @@
>   */
> 
>  #include <linux/fs.h>
> +#include <asm/page.h> /* for PAGE_SIZE */
> 
>  #include "befs.h"
>  #include "super.h"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Martin Michlmayr
http://www.cyrius.com/
