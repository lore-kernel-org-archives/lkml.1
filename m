Return-Path: <linux-kernel-owner+w=401wt.eu-S1751942AbZIBLvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbZIBLvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZIBLvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:51:36 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:44138 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZIBLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:51:36 -0400
Date: Wed, 02 Sep 2009 20:51:37 +0900 (JST)
Message-Id: <20090902.205137.71100180.ryov@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, linux-mm@kvack.org
Subject: a room for blkio-cgroup in struct page_cgroup
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamezawa-san,

As you wrote before (http://lkml.org/lkml/2009/7/22/65)
> To be honest, what I expected in these days for people of blockio
> cgroup is like following for getting room for themselves.
<<snip>>
> --- mmotm-2.6.31-Jul16.orig/include/linux/page_cgroup.h
> +++ mmotm-2.6.31-Jul16/include/linux/page_cgroup.h
> @@ -13,7 +13,7 @@
>  struct page_cgroup {
>       unsigned long flags;
>       struct mem_cgroup *mem_cgroup;
> -     struct page *page;
> +     /* block io tracking will use extra unsigned long bytes */
>       struct list_head lru;       /* per cgroup LRU list */
> };

Have you already added a room for blkio_cgroup in struct page_cgroup?
If not, I would like you to apply the above change to mmotm.

The latest blkio-cgroup has reflected the comments you pointed out.
I would also like you to give me any comments on it and consider
merging blkio-cgroup to mmotm.

Thank you for your help in advance.
Ryo Tsuruta
