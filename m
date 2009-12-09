Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbZLIJPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbZLIJPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZLIJPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:15:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48304 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZLIJPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:15:03 -0500
Date: Wed, 9 Dec 2009 10:15:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, kosaki.motohiro@jp.fujitsu.com,
       hugh.dickins@tiscali.co.uk, nishimura@mxp.nes.nec.co.jp,
       balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       menage@google.com, npiggin@suse.de, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [23/31] HWPOISON: add memory cgroup filter
Message-ID: <20091209091510.GE18989@one.firstfloor.org>
References: <200912081016.198135742@firstfloor.org> <20091208211639.8499FB151F@basil.firstfloor.org> <4B1F2FC6.7040406@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1F2FC6.7040406@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a question, can try_get_mem_cgroup_from_page() return
> root_mem_cgroup?

It could be called for any page.


> if it can, then css->cgroup->dentry is NULL, if memcg is
> not mounted and there is no subdir in memcg. Because the root
> cgroup of an inactive subsystem has no dentry.

Thanks. I'll just add an return -EINVAL for this case, sounds good?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
