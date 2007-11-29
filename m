Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbXK2Ddh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbXK2Ddh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 22:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbXK2Dd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 22:33:29 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:42582 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754383AbXK2Dd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 22:33:28 -0500
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [3/10] per-zone active inactive counter
In-Reply-To: Your message of "Tue, 27 Nov 2007 12:00:48 +0900"
	<20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20071129033328.20E5F1CFEAA@siro.lan>
Date: Thu, 29 Nov 2007 12:33:28 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline struct mem_cgroup_per_zone *
> +mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
> +{
> +	if (!mem->info.nodeinfo[nid])

can this be true?

YAMAMOTO Takashi

> +		return NULL;
> +	return &mem->info.nodeinfo[nid]->zoneinfo[zid];
> +}
> +
