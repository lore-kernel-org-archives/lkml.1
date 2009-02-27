Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbZB0BjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbZB0BjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZB0BjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:39:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38163 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZB0BjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:39:01 -0500
Date: Fri, 27 Feb 2009 10:37:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hannes Eder <hannes@hanneseder.net>
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] memcg: fix sparse warning: Using plain integer as
  NULL pointer
Message-Id: <20090227103742.8376ab5c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <154e089b0902261715p3d1a865ep845e0f1345549ebb@mail.gmail.com>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	<20090222000532.17557.52930.stgit@vmbox.hanneseder.net>
	<154e089b0902261715p3d1a865ep845e0f1345549ebb@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 02:15:46 +0100
Hannes Eder <hannes@hanneseder.net> wrote:

> [Added To]
> 
Thanks,

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> On Sun, Feb 22, 2009 at 1:05 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> > Fix this sparse warning:
> >  mm/memcontrol.c:1637:32: warning: Using plain integer as NULL pointer
> >
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> > ---
> >  mm/memcontrol.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 8e4be9c..09d6650 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1634,7 +1634,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *mem,
> >                pc = list_entry(list->prev, struct page_cgroup, lru);
> >                if (busy == pc) {
> >                        list_move(&pc->lru, list);
> > -                       busy = 0;
> > +                       busy = NULL;
> >                        spin_unlock_irqrestore(&zone->lru_lock, flags);
> >                        continue;
> >                }
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

