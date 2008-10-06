Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbYJFHmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbYJFHmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 03:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYJFHmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 03:42:31 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:43654 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751512AbYJFHmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 03:42:31 -0400
Date: Mon, 6 Oct 2008 13:12:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 1/6] atomic page_cgroup flags
Message-ID: <20081006074223.GA1202@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
References: <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com> <20081001165513.7633c132.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081001165513.7633c132.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-10-01 16:55:13]:

> This patch makes page_cgroup->flags to be atomic_ops and define
> functions (and macros) to access it.
> 
> Before trying to modify memory resource controller, this atomic operation
> on flags is necessary. Most of flags in this patch is for LRU and modfied
> under mz->lru_lock but we'll add another flags which is not for LRU soon.
> (lock_page_cgroup() will use LOCK bit on page_cgroup->flags)
> So we use atomic version here.
>

Seems quite straightforward

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 

-- 
	Balbir
