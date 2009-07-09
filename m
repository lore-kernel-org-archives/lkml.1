Return-Path: <linux-kernel-owner+w=401wt.eu-S1761143AbZGIOxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761143AbZGIOxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbZGIOwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:52:54 -0400
Received: from relay3.sgi.com ([192.48.156.57]:34335 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753072AbZGIOwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:52:53 -0400
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: felixb@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 34/44] includecheck fix: fs/xfs, xfs_iops.c
References: <1247063308.4382.12.camel@ht.satnam>
	<1247067971.4382.94.camel@ht.satnam>
From: Olaf Weber <olaf@sgi.com>
Date: Thu, 09 Jul 2009 16:52:48 +0200
In-Reply-To: <1247067971.4382.94.camel@ht.satnam> (Jaswinder Singh Rajput's message of "Wed, 08 Jul 2009 21:16:11 +0530")
Message-ID: <bzyhbxlx60v.fsf@fransum.emea.sgi.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.3 (irix)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput writes:

> fix the following 'make includecheck' warning:

>   fs/xfs/linux-2.6/xfs_iops.c: xfs_acl.h is included more than once.

> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-By: Olaf Weber <olaf@sgi.com>



> ---
>  fs/xfs/linux-2.6/xfs_iops.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> index 58973bb..793a146 100644
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -43,7 +43,6 @@
>  #include "xfs_error.h"
>  #include "xfs_itable.h"
>  #include "xfs_rw.h"
> -#include "xfs_acl.h"
>  #include "xfs_attr.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_utils.h"
> -- 
> 1.6.0.6

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com
