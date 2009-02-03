Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZBCBcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZBCBcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZBCBcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:32:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43553 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZBCBcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:32:09 -0500
Date: Tue, 3 Feb 2009 10:30:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] trivial: Give the right path in Documentation example
Message-Id: <20090203103056.c4e097b3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1233614376-27654-1-git-send-email-cascardo@holoscopio.com>
References: <1233614376-27654-1-git-send-email-cascardo@holoscopio.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Feb 2009 20:39:36 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> While the Documentation example creates /cgroup/test, it removes
> /test/cgroup, which is clearly not the intended path. Change that to
> /cgroup/test.
> 
Ah, thanks.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  Documentation/cgroups/memcg_test.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
> index 523a9c1..a926359 100644
> --- a/Documentation/cgroups/memcg_test.txt
> +++ b/Documentation/cgroups/memcg_test.txt
> @@ -356,7 +356,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
>  	(Shell-B)
>  	# move all tasks in /cgroup/test to /cgroup
>  	# /sbin/swapoff -a
> -	# rmdir /test/cgroup
> +	# rmdir /cgroup/test
>  	# kill malloc task.
>  
>  	Of course, tmpfs v.s. swapoff test should be tested, too.
> -- 
> 1.6.0.6
> 
> 

