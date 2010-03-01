Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab0CAF0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:26:52 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38670 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0CAF0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:26:50 -0500
Date: Mon, 1 Mar 2010 10:56:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix typos in memcg_test.txt
Message-ID: <20100301052643.GH19665@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1267191557-23444-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1267191557-23444-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill A. Shutemov <kirill@shutemov.name> [2010-02-26 15:39:16]:

> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  Documentation/cgroups/memcg_test.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
> index 4d32e0e..f7f68b2 100644
> --- a/Documentation/cgroups/memcg_test.txt
> +++ b/Documentation/cgroups/memcg_test.txt
> @@ -337,7 +337,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
>  	race and lock dependency with other cgroup subsystems.
> 
>  	example)
> -	# mount -t cgroup none /cgroup -t cpuset,memory,cpu,devices
> +	# mount -t cgroup none /cgroup -o cpuset,memory,cpu,devices
> 
>  	and do task move, mkdir, rmdir etc...under this.
> 
> @@ -348,7 +348,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
> 
>  	For example, test like following is good.
>  	(Shell-A)
> -	# mount -t cgroup none /cgroup -t memory
> +	# mount -t cgroup none /cgroup -o memory
>  	# mkdir /cgroup/test
>  	# echo 40M > /cgroup/test/memory.limit_in_bytes
>  	# echo 0 > /cgroup/test/tasks


Looks good,

Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
