Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYJFQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYJFQcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYJFQcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:32:48 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:38508 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752842AbYJFQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:32:47 -0400
Date: Mon, 6 Oct 2008 22:02:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 2/6] memcg: allocate page_cgroup at boot (hunk fix)
Message-ID: <20081006163238.GC1202@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
References: <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com> <20081001165603.a6e73c0d.kamezawa.hiroyu@jp.fujitsu.com> <20081002174945.4034cc9f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081002174945.4034cc9f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-10-02 17:49:45]:

> Index: mmotm-2.6.27-rc7+/include/linux/mm_types.h
> ===================================================================
> --- mmotm-2.6.27-rc7+.orig/include/linux/mm_types.h
> +++ mmotm-2.6.27-rc7+/include/linux/mm_types.h
> @@ -94,10 +94,6 @@ struct page {
>  	void *virtual;			/* Kernel virtual address (NULL if
>  					   not kmapped, ie. highmem) */
>  #endif /* WANT_PAGE_VIRTUAL */
> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> -	unsigned long page_cgroup;
> -#endif
> -

Just FYI, this hunk fails for mmotm Oct 2nd, applied on top of
2.6.27-rc8, the space after the #endif is gone

-- 
	Balbir
