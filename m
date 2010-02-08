Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0BHSvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:51:22 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:43776 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753963Ab0BHSvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:51:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mBCG+lqSO631pQO1LbSX2lD9YfAFkhmr/CmAnCFN8j/ghTlgExgkATcBhDNDy+UI0uKhiQFKbTxguL9prTARxJV6UqEA3i4mcZ6MYHnMF667Yex8L7Xkz13K3mSqM1X7;
Date: Mon, 8 Feb 2010 10:50:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH -next] pci hotplug: fix ibmphp build error
Message-ID: <20100208105012.17053238@jbarnes-piketon>
In-Reply-To: <4B6B2A27.9070600@oracle.com>
References: <20100204185736.6628ab9a.sfr@canb.auug.org.au>
	<4B6B2A27.9070600@oracle.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Feb 2010 12:12:23 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add header file to fix build error:
> 
> drivers/pci/hotplug/ibmphp_hpc.c:135: error: implicit declaration of
> function 'init_MUTEX' drivers/pci/hotplug/ibmphp_hpc.c:136: error:
> implicit declaration of function 'init_MUTEX_LOCKED'
> drivers/pci/hotplug/ibmphp_hpc.c:797: error: implicit declaration of
> function 'down' drivers/pci/hotplug/ibmphp_hpc.c:807: error: implicit
> declaration of function 'up'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>   drivers/pci/hotplug/ibmphp_hpc.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- linux-next-20100204.orig/drivers/pci/hotplug/ibmphp_hpc.c
> +++ linux-next-20100204/drivers/pci/hotplug/ibmphp_hpc.c
> @@ -35,6 +35,7 @@
>   #include <linux/init.h>
>   #include <linux/mutex.h>
>   #include <linux/sched.h>
> +#include <linux/semaphore.h>
>   #include <linux/kthread.h>
>   #include "ibmphp.h"
>   
> 

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
