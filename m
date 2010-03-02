Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0CBWVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:21:21 -0500
Received: from tundra.namei.org ([65.99.196.166]:33668 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0CBWVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:21:20 -0500
Date: Wed, 3 Mar 2010 09:21:19 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: wzt.wzt@gmail.com
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Selinux: Remove unused headers list.h in
 selinux/netlink.c
In-Reply-To: <20100302070858.GA5178@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1003030921110.14492@tundra.namei.org>
References: <20100302070858.GA5178@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010, wzt.wzt@gmail.com wrote:

> list.h is unused in netlink.c, so remove it.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-queue

> 
> ---
>  security/selinux/netlink.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/security/selinux/netlink.c b/security/selinux/netlink.c
> index 1ae5564..7d7be29 100644
> --- a/security/selinux/netlink.c
> +++ b/security/selinux/netlink.c
> @@ -13,7 +13,6 @@
>  #include <linux/types.h>
>  #include <linux/stddef.h>
>  #include <linux/kernel.h>
> -#include <linux/list.h>
>  #include <linux/skbuff.h>
>  #include <linux/netlink.h>
>  #include <linux/selinux_netlink.h>
> -- 
> 1.6.5.3
> 

-- 
James Morris
<jmorris@namei.org>
