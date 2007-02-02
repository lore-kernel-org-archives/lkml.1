Return-Path: <linux-kernel-owner+w=401wt.eu-S1422748AbXBBLRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422748AbXBBLRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422775AbXBBLRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:17:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:2593 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422748AbXBBLRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:17:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L31m+ZLxbI3BcvYxFBKe3imyuj2rDXulBIOk/N5tGfx8lRArLVdEvjGGL8YZc0k5t2kCP3WiAxRErIbtmhGwPgXcxfjx1foxxIHpilVfb02t4gZ2u77lLLl+9O8z6xVsHhsmrsXGivFUwIT3DxkjcVuvZyDR31WhAvYDdHMq1yM=
Message-ID: <b6fcc0a0702020317j5776bc3ar5b1db481501c81c0@mail.gmail.com>
Date: Fri, 2 Feb 2007 14:17:50 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] REISERFS: Rename incorrect macro name "REISERFS_PROC_INFO".
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       reiserfs-dev@namesys.com
In-Reply-To: <Pine.LNX.4.64.0702020447001.12400@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702020447001.12400@CPE00045a9c397f-CM001225dbafb6>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>   Rename the incorrect macro name "REISERFS_PROC_INFO" to
> "CONFIG_REISERFS_PROC_INFO".

It isn't incorrect. It's setup in reiserfs header files.
You reminded me to dig out "reiserfs without proc files" cleanup which
will get rid of REISERFS_PROC_INFO completely.

> --- a/fs/reiserfs/procfs.c
> +++ b/fs/reiserfs/procfs.c
> @@ -20,7 +20,7 @@
>  #include <linux/init.h>
>  #include <linux/proc_fs.h>
>
> -#if defined( REISERFS_PROC_INFO )
> +#if defined( CONFIG_REISERFS_PROC_INFO )
