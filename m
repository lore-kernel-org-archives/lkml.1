Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab0CKAqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 19:46:18 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61765 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab0CKAqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 19:46:17 -0500
Date: Thu, 11 Mar 2010 09:32:26 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Greg Thelen <gthelen@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] mm: fix typo in refill_stock() comment
Message-Id: <20100311093226.8f361e38.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1268255117-3280-1-git-send-email-gthelen@google.com>
References: <1268255117-3280-1-git-send-email-gthelen@google.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010 13:05:17 -0800, Greg Thelen <gthelen@google.com> wrote:
> Change refill_stock() comment: s/consumt_stock()/consume_stock()/
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thanks,
Daisuke Nishimura.
> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d813823..0576de1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1330,7 +1330,7 @@ static void drain_local_stock(struct work_struct *dummy)
>  
>  /*
>   * Cache charges(val) which is from res_counter, to local per_cpu area.
> - * This will be consumed by consumt_stock() function, later.
> + * This will be consumed by consume_stock() function, later.
>   */
>  static void refill_stock(struct mem_cgroup *mem, int val)
>  {
> -- 
> 1.7.0.1
> 
