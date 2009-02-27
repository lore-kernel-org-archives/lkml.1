Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbZB0BQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbZB0BQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZB0BPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:15:50 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:58673 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZB0BPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:15:49 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000532.17557.52930.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000532.17557.52930.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 02:15:46 +0100
Message-ID: <154e089b0902261715p3d1a865ep845e0f1345549ebb@mail.gmail.com>
Subject: Re: [PATCH 14/16] memcg: fix sparse warning: Using plain integer as 
	NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To]

On Sun, Feb 22, 2009 at 1:05 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warning:
>  mm/memcontrol.c:1637:32: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8e4be9c..09d6650 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1634,7 +1634,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *mem,
>                pc = list_entry(list->prev, struct page_cgroup, lru);
>                if (busy == pc) {
>                        list_move(&pc->lru, list);
> -                       busy = 0;
> +                       busy = NULL;
>                        spin_unlock_irqrestore(&zone->lru_lock, flags);
>                        continue;
>                }
>
>
