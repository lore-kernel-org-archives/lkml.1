Return-Path: <linux-kernel-owner+w=401wt.eu-S1760586AbZKZOqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbZKZOqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760561AbZKZOqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:46:44 -0500
Received: from daytona.panasas.com ([67.152.220.89]:40483 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760558AbZKZOql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:46:41 -0500
Message-ID: <4B0E94D4.5090800@panasas.com>
Date: Thu, 26 Nov 2009 16:46:44 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Remi/fc10 Thunderbird/3.0
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       NFS list <linux-nfs@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] parsic: remove unused nfsd #includes
References: <4B0C1EB7.50508@panasas.com> <4B0C1F1A.8070605@panasas.com>
In-Reply-To: <4B0C1F1A.8070605@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2009 14:46:48.0168 (UTC) FILETIME=[48191E80:01CA6EA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 11:27 PM, Grant Grundler wrote:
> On Tue, Nov 24, 2009 at 07:58:15PM +0200, Boaz Harrosh wrote:
>> Some arch files had unneeded #includes directives from linux/nfsd/*.
>> Some vfs files had unneeded #includes directives from linux/nfsd/*.
> ...
>> patches:
>> [PATCH 1/5] parsic: remove unused nfsd #includes
>> 	Some kind soul, please compile with this patch? compile
>> 	is all that's needed.
> 
> Boaz,
> linux-2.6 compiles for parisc with this patch. Please add:
>     Tested-by: Grant Grundler <grundler@parisc-linux.org>
> 
> thanks,
> grant
> 

CCing registered parsic maintainers. Could we please get an ACK on
this patch, and cary this through the nfsd tree?

Thanks 
Boaz

On 11/24/2009 07:59 PM, Boaz Harrosh wrote:
> 
> Some unused includes removed.
> 
> This patch is in an effort to cleanup nfsd headers and move
> private definitions to source directory.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  arch/parisc/kernel/sys_parisc32.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
> index 561388b..4a8ca63 100644
> --- a/arch/parisc/kernel/sys_parisc32.c
> +++ b/arch/parisc/kernel/sys_parisc32.c
> @@ -26,13 +26,7 @@
>  #include <linux/shm.h>
>  #include <linux/slab.h>
>  #include <linux/uio.h>
> -#include <linux/nfs_fs.h>
>  #include <linux/ncp_fs.h>
> -#include <linux/sunrpc/svc.h>
> -#include <linux/nfsd/nfsd.h>
> -#include <linux/nfsd/cache.h>
> -#include <linux/nfsd/xdr.h>
> -#include <linux/nfsd/syscall.h>
>  #include <linux/poll.h>
>  #include <linux/personality.h>
>  #include <linux/stat.h>

