Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYBRGWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYBRGWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYBRGWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:22:12 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:43650 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993AbYBRGWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:22:10 -0500
To: balbir@linux.vnet.ibm.com
Cc: lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] memcgroup: fix typo in VM_BUG_ON()
In-Reply-To: Your message of "Mon, 18 Feb 2008 11:44:20 +0530"
	<47B9223C.9020106@linux.vnet.ibm.com>
References: <47B9223C.9020106@linux.vnet.ibm.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080218062209.DA59B1E3C58@siro.lan>
Date: Mon, 18 Feb 2008 15:22:09 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Li Zefan wrote:
> > No need for VM_BUG_ON(pc), since 'pc' is the list entry. This should
> > be VM_BUG_ON(page).
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> pc is of type page_cgroup and we use list_for_each_entry_safe_reverse. Not sure
> why we can't bug on pc.

pc is dereferenced before this VM_BUG_ON.

YAMAMOTO Takashi

> 
> 
> 
> -- 
> 	Warm Regards,
> 	Balbir Singh
> 	Linux Technology Center
> 	IBM, ISTL
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
