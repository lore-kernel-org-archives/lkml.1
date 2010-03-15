Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab0COFCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:02:48 -0400
Received: from UNIX31.andrew.cmu.edu ([128.2.13.161]:48416 "EHLO
	unix31.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab0COFCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:02:47 -0400
X-Greylist: delayed 1841 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 01:02:46 EDT
Date: Mon, 15 Mar 2010 00:31:43 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
       Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>,
       Ben Blum <bblum@andrew.cmu.edu>, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Subject: Re: [PATCH] block: make CONFIG_BLK_CGROUP visible
Message-ID: <20100315043143.GA7953@unix31.andrew.cmu.edu>
References: <4B9DA6F5.3070606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9DA6F5.3070606@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 11:18:13AM +0800, Li Zefan wrote:
> Make the config visible, so we can choose from CONFIG_BLK_CGROUP=y
> and CONFIG_BLK_CGROUP=m when CONFIG_IOSCHED_CFQ=m.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  block/Kconfig |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index 62a5921..906950c 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -78,8 +78,9 @@ config BLK_DEV_INTEGRITY
>  	Protection.  If in doubt, say N.
>  
>  config BLK_CGROUP
> -	tristate
> +	tristate "Block cgroup support"
>  	depends on CGROUPS
> +	depends on CFQ_GROUP_IOSCHED
>  	default n
>  	---help---
>  	Generic block IO controller cgroup interface. This is the common
> @@ -91,7 +92,7 @@ config BLK_CGROUP
>  	to such task groups.
>  
>  config DEBUG_BLK_CGROUP
> -	bool
> +	bool "Block cgroup debugging help"
>  	depends on BLK_CGROUP
>  	default n
>  	---help---
> -- 
> 1.6.3
> 
> 

LGTM.

Acked-by: Ben Blum <bblum@andrew.cmu.edu>
