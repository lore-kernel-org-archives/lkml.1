Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYIQFoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYIQFoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 01:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYIQFn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 01:43:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53653 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYIQFn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 01:43:56 -0400
Date: Wed, 17 Sep 2008 14:50:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, xemul@openvz.org
Subject: Re: [PATCH -mm] memcg: fix handling of shmem migration
Message-Id: <20080917145003.fb4d0b95.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080917144659.2e363edc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080917133149.b012a1c2.nishimura@mxp.nes.nec.co.jp>
	<20080917144659.2e363edc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 14:46:59 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 17 Sep 2008 13:31:49 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > PG_swapbacked flag of newpage should be set(if needed) before
> > mem_cgroup_prepare_migration, because mem_cgroup_charge_common
> > checks the flag and determines whether it sets PAGE_CGROUP_FLAG_FILE or not.
> > 
> > Before this patch, if migrating shmem/tmpfs pages, newpage would be
> > charged with PAGE_CGROUP_FLAG_FILE set, while oldpage has been charged
> > without the flag.
> > 
> Nice catch !
> Thank you. 
> 
> Hmm, should I add MEM_CGROUP_CHARGE_TYPE_SHMEM rather than
> setting flag to newpage ?
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
I acked but.. can't this change moved into memcontrol.c ?

Thanks,
-Kame

